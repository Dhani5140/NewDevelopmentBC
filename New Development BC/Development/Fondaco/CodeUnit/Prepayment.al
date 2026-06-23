codeunit 70001 Prepay
{
    Permissions = TableData "Sales Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "General Posting Setup" = rimd,
                  tabledata "G/L Entry" = rimd;
    TableNo = "Sales Header";
    trigger OnRun()
    begin

    end;


    procedure "Code"(var SalesHeader2: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo"; Line: Record MiiTabScheduleLine)
    var
        SourceCodeSetup: Record "Source Code Setup";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TempPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempSalesLines: Record "Sales Line" temporary;
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        DocumentTotals: Codeunit "Document Totals";
        Window: Dialog;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        PostingNoSeriesCode: Code[20];
        ModifyHeader: Boolean;
        IsHandled: Boolean;
        ShouldSetPendingPrepaymentStatus: Boolean;
        CalcPmtDiscOnCrMemos: Boolean;
        PostingDescription: Text[100];
        GenJnlLineDocType: Enum "Gen. Journal Document Type";
        PrevLineNo: Integer;
        LineCount: Integer;
        PostedDocTabNo: Integer;
        LineNo: Integer;
    begin
        updateprepayment(SalesHeader2, Line);

        SalesHeader := SalesHeader2;
        GLSetup.GetRecordOnce();
        SalesSetup.Get();

        if (SalesSetup."Calc. Inv. Discount" and (SalesHeader.Status = SalesHeader.Status::Open)) then
            DocumentTotals.SalesRedistributeInvoiceDiscountAmountsOnDocument(SalesHeader);

        CheckPrepmtDoc(SalesHeader, DocumentType);

        UpdateDocNos(SalesHeader, DocumentType, GenJnlLineDocNo, PostingNoSeriesCode, ModifyHeader);

        if not PreviewMode and ModifyHeader then begin
            SalesHeader.Modify();
            if not SuppressCommit then
                Commit();
        end;

        if GuiAllowed then begin
            Window.Open(
            '#1#################################\\' +
            Text002 +
            Text004 +
            Text005 +
            Text006);
            Window.Update(1, StrSubstNo(UpdateTok, SelectStr(1 + DocumentType, Text019), SalesHeader."No."));
        end;

        SourceCodeSetup.Get();
        SrcCode := SourceCodeSetup.Sales;
        if SalesHeader."Prepmt. Posting Description" <> '' then
            PostingDescription := SalesHeader."Prepmt. Posting Description"
        else
            PostingDescription :=
              CopyStr(
                StrSubstNo(Text012, SelectStr(1 + DocumentType, Text019), SalesHeader."Document Type", SalesHeader."No."),
                1, MaxStrLen(SalesHeader."Posting Description"));

        // Create posted header
        if SalesSetup."Ext. Doc. No. Mandatory" then
            SalesHeader.TestField("External Document No.");

        case DocumentType of
            DocumentType::Invoice:
                begin
                    InsertSalesInvHeader(SalesInvHeader, SalesHeader, PostingDescription, GenJnlLineDocNo, SrcCode, PostingNoSeriesCode);
                    GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
                    PostedDocTabNo := Database::"Sales Invoice Header";
                    if GuiAllowed then
                        Window.Update(1, StrSubstNo(Text003, SalesHeader."Document Type", SalesHeader."No.", SalesInvHeader."No."));
                end;
            DocumentType::"Credit Memo":
                begin
                    CalcPmtDiscOnCrMemos := GetCalcPmtDiscOnCrMemos(SalesHeader."Prepmt. Payment Terms Code");
                    InsertSalesCrMemoHeader(
                      SalesCrMemoHeader, SalesHeader, PostingDescription, GenJnlLineDocNo, SrcCode, PostingNoSeriesCode,
                      CalcPmtDiscOnCrMemos);
                    GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
                    PostedDocTabNo := Database::"Sales Cr.Memo Header";
                    if GuiAllowed then
                        Window.Update(1, StrSubstNo(Text011, SalesHeader."Document Type", SalesHeader."No.", SalesCrMemoHeader."No."));
                end;
        end;
        GenJnlLineExtDocNo := SalesHeader."External Document No.";
        // Reverse old lines
        if DocumentType = DocumentType::Invoice then begin
            GetSalesLinesToDeduct(SalesHeader, TempSalesLines);
            if not TempSalesLines.IsEmpty() then
                CalcVATAmountLines(SalesHeader, TempSalesLines, TempVATAmountLineDeduct, DocumentType::"Credit Memo");
        end;
        // Create Lines
        TempPrepmtInvLineBuffer.DeleteAll();

        IsHandled := false;
        if not IsHandled then begin
            CalcVATAmountLines(SalesHeader, SalesLine, TempVATAmountLine, DocumentType);
            TempVATAmountLine.DeductVATAmountLine(TempVATAmountLineDeduct);
            UpdateVATOnLines(SalesHeader, SalesLine, TempVATAmountLine, DocumentType);
            BuildInvLineBuffer(SalesHeader, SalesLine, DocumentType, TempPrepmtInvLineBuffer, true);
        end;

        CreateLinesFromBuffer(SalesHeader, SalesLine, TempPrepmtInvLineBuffer, SalesInvHeader, SalesCrMemoHeader, PrevLineNo, LineCount, PostedDocTabNo, LineNo, DocumentType, Window, GenJnlLineDocNo);

        // G/L Posting
        LineCount := 0;
        if not SalesHeader."Compress Prepayment" then
            TempPrepmtInvLineBuffer.CompressBuffer();
        TempPrepmtInvLineBuffer.SetRange(Adjustment, false);
        TempPrepmtInvLineBuffer.FindSet(true);
        repeat
            if DocumentType = DocumentType::Invoice then
                TempPrepmtInvLineBuffer.ReverseAmounts();
            RoundAmounts(SalesHeader, TempPrepmtInvLineBuffer, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY);
            if SalesHeader."Currency Code" = '' then begin
                AdjustInvLineBuffers(SalesHeader, TempPrepmtInvLineBuffer, TotalPrepmtInvLineBuffer, DocumentType);
                TotalPrepmtInvLineBufferLCY := TotalPrepmtInvLineBuffer;
            end else
                AdjustInvLineBuffers(SalesHeader, TempPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY, DocumentType);
            TempPrepmtInvLineBuffer.Modify();
        until TempPrepmtInvLineBuffer.Next() = 0;

        TempPrepmtInvLineBuffer.Reset();
        TempPrepmtInvLineBuffer.SetCurrentKey(Adjustment);
        TempPrepmtInvLineBuffer.Find('+');
        repeat
            LineCount := LineCount + 1;
            if GuiAllowed then
                Window.Update(3, LineCount);

            PostPrepmtInvLineBuffer(
              SalesHeader, TempPrepmtInvLineBuffer, DocumentType, PostingDescription,
              GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PostingNoSeriesCode);
        until TempPrepmtInvLineBuffer.Next(-1) = 0;
        // Post customer entry
        if GuiAllowed then
            Window.Update(4, 1);
        PostCustomerEntry(
          SalesHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY, DocumentType, PostingDescription,
          GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PostingNoSeriesCode, CalcPmtDiscOnCrMemos);

        UpdatePostedSalesDocument(DocumentType, GenJnlLineDocNo, CustLedgEntry);

        SalesAssertPrepmtAmountNotMoreThanDocAmount(CustLedgEntry, SalesHeader, SalesLine);
        // Balancing account
        if SalesHeader."Bal. Account No." <> '' then begin
            if GuiAllowed then
                Window.Update(5, 1);
            PostBalancingEntry(
              SalesHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY, CustLedgEntry, DocumentType,
              PostingDescription, GenJnlLineDocType, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, PostingNoSeriesCode);
        end;
        // Update lines & header
        UpdateSalesDocument(SalesHeader, SalesLine, DocumentType, GenJnlLineDocNo);
        ShouldSetPendingPrepaymentStatus := SalesHeader.TestStatusIsNotPendingPrepayment();
        // if ShouldSetPendingPrepaymentStatus then
        //     SalesHeader.Status := SalesHeader.Status::"Pending Prepayment";
        SalesHeader.Modify();

        Line.CustLedgerNo := GenJnlLineDocNo;
        Line.Status := Line.Status::Paid;
        Line.Modify();

        if PreviewMode then begin
            if GuiAllowed then
                Window.Close();
            GenJnlPostPreview.ThrowError();
        end;

        SalesHeader2 := SalesHeader;
    end;

    local procedure RoundAmounts(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBufLCY: Record "Prepayment Inv. Line Buffer")
    var
        VAT: Boolean;
    begin
        TotalPrepmtInvLineBuf.IncrAmounts(PrepmtInvLineBuf);

        if SalesHeader."Currency Code" <> '' then begin
            VAT := PrepmtInvLineBuf.Amount <> PrepmtInvLineBuf."Amount Incl. VAT";
            PrepmtInvLineBuf."Amount Incl. VAT" :=
              AmountToLCY(SalesHeader, TotalPrepmtInvLineBuf."Amount Incl. VAT", TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
            if VAT then
                PrepmtInvLineBuf.Amount := AmountToLCY(SalesHeader, TotalPrepmtInvLineBuf.Amount, TotalPrepmtInvLineBufLCY.Amount)
            else
                PrepmtInvLineBuf.Amount := PrepmtInvLineBuf."Amount Incl. VAT";
            PrepmtInvLineBuf."VAT Amount" := PrepmtInvLineBuf."Amount Incl. VAT" - PrepmtInvLineBuf.Amount;
            if PrepmtInvLineBuf."VAT Base Amount" <> 0 then
                PrepmtInvLineBuf."VAT Base Amount" := PrepmtInvLineBuf.Amount;
            PrepmtInvLineBuf."Orig. Pmt. Disc. Possible" :=
              AmountToLCY(
                SalesHeader,
                TotalPrepmtInvLineBuf."Orig. Pmt. Disc. Possible", TotalPrepmtInvLineBufLCY."Orig. Pmt. Disc. Possible");
        end;
        TotalPrepmtInvLineBufLCY.IncrAmounts(PrepmtInvLineBuf);
    end;

    local procedure PostCustomerEntry(SalesHeader: Record "Sales Header"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo"; PostingDescription: Text[100]; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Text[35]; SrcCode: Code[10]; PostingNoSeriesCode: Code[20]; CalcPmtDisc: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
        IsHandled: Boolean;
        Header: Record MiiTabScheduleHeader;
    begin
        IsHandled := false;
        if not IsHandled then begin
            GenJnlLine.InitNewLine(
                SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."VAT Reporting Date", PostingDescription,
                SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
                SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

            Header.SetFilter("Document No.", '%1', SalesHeader."No.");
            Header.FindFirst();

            GenJnlLine.CopyDocumentFields(DocType, DocNo, ExtDocNo, SrcCode, PostingNoSeriesCode);

            GenJnlLine.CopyFromSalesHeaderPrepmtPost(SalesHeader, (DocumentType = DocumentType::Invoice) or CalcPmtDisc);

            // GenJnlLine.Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            // GenJnlLine."Source Currency Amount" := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            // GenJnlLine."Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT";
            // GenJnlLine."Sales/Purch. (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
            // GenJnlLine."Profit (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
            //update type ke payment
            GenJnlLine.Amount := TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            GenJnlLine."Source Currency Amount" := TotalPrepmtInvLineBuffer."Amount Incl. VAT";
            GenJnlLine."Amount (LCY)" := TotalPrepmtInvLineBufferLCY."Amount Incl. VAT";
            GenJnlLine."Sales/Purch. (LCY)" := TotalPrepmtInvLineBufferLCY.Amount;
            GenJnlLine."Profit (LCY)" := TotalPrepmtInvLineBufferLCY.Amount;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;

            GenJnlLine.Correction := (DocumentType = DocumentType::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

            GenJnlLine."Orig. Pmt. Disc. Possible" := -TotalPrepmtInvLineBuffer."Orig. Pmt. Disc. Possible";
            GenJnlLine."Orig. Pmt. Disc. Possible(LCY)" := -TotalPrepmtInvLineBufferLCY."Orig. Pmt. Disc. Possible";
            if GLSetup."Journal Templ. Name Mandatory" then
                GenJnlLine."Journal Template Name" := GenJournalTemplate.Name;

            GenJnlLine."Prepmt. Bank" := Header."No.";

            GenJnlLine."Blanket No." := SalesHeader."No.";

            Clear(GenJnlLine."Pmt. Discount Date");
            Clear(GenJnlLine."Payment Discount %");

            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure SalesAssertPrepmtAmountNotMoreThanDocAmount(var CustLedgEntry: Record "Cust. Ledger Entry"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if CustLedgEntry."Entry No." = 0 then // Fallback if the Customer Ledger Entry was not provided from UpdatePostedSalesDocument or the event
            CustLedgEntry.FindLast();

        CustLedgEntry.CalcFields(Amount);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Blanket Order" then begin
            SalesLine.CalcSums("Amount Including VAT");
            PrepaymentMgt.AssertPrepmtAmountNotMoreThanDocAmount(
                SalesLine."Amount Including VAT", CustLedgEntry.Amount, SalesHeader."Currency Code", SalesSetup."Invoice Rounding");
        end;
    end;

    local procedure UpdateDocNos(var SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo"; var DocNo: Code[20]; var NoSeriesCode: Code[20]; var ModifyHeader: Boolean)
    var
        IsHandled: Boolean;
    begin
        ModifyHeader := false;
        case DocumentType of
            DocumentType::Invoice:
                begin
                    SalesHeader.TestField("Prepayment Due Date");
                    SalesHeader.TestField("Prepmt. Cr. Memo No.", '');
                    //if SalesHeader."Prepayment No." = '' then
                    if not PreviewMode then
                        UpdateInvoiceDocNos(SalesHeader, ModifyHeader)
                    else
                        SalesHeader."Prepayment No." := '***';
                    DocNo := SalesHeader."Prepayment No.";
                    NoSeriesCode := SalesHeader."Prepayment No. Series";
                end;
            DocumentType::"Credit Memo":
                begin
                    SalesHeader.TestField("Prepayment No.", '');
                    if SalesHeader."Prepmt. Cr. Memo No." = '' then
                        if not PreviewMode then
                            UpdateCrMemoDocNos(SalesHeader, ModifyHeader)
                        else
                            SalesHeader."Prepmt. Cr. Memo No." := '***';
                    DocNo := SalesHeader."Prepmt. Cr. Memo No.";
                    NoSeriesCode := SalesHeader."Prepmt. Cr. Memo No. Series";
                end;
        end;

        if GLSetup."Journal Templ. Name Mandatory" then
            GenJournalTemplate.Get(SalesHeader."Journal Templ. Name");

    end;

    local procedure UpdateCrMemoDocNos(var SalesHeader: Record "Sales Header"; var ModifyHeader: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
        ErrorContextElement: Codeunit "Error Context Element";
    begin
        if GLSetup."Journal Templ. Name Mandatory" then begin
            SalesReceivablesSetup.GetRecordOnce();
            SalesReceivablesSetup.TestField("S. Prep. Cr.Memo Template Name");
            GenJournalTemplate.Get(SalesReceivablesSetup."S. Prep. Cr.Memo Template Name");
            GenJournalTemplate.TestField("Posting No. Series");
            SalesHeader."Prepmt. Cr. Memo No." := NoSeries.GetNextNo(GenJournalTemplate."Posting No. Series", SalesHeader."Posting Date");
            ModifyHeader := true;
        end else begin
            if SalesHeader."Prepmt. Cr. Memo No. Series" = '' then begin
                SalesReceivablesSetup.Get();
                ErrorMessageMgt.PushContext(ErrorContextElement, SalesReceivablesSetup.RecordId, 0, '');
                if SalesReceivablesSetup."Posted Prepmt. Cr. Memo Nos." = '' then
                    ErrorMessageMgt.LogContextFieldError(
                        SalesReceivablesSetup.FieldNo("Posted Prepmt. Cr. Memo Nos."), SpecifyCrNoSerieTok,
                        SalesReceivablesSetup.RecordId, SalesReceivablesSetup.FieldNo("Posted Prepmt. Cr. Memo Nos."), '');
                ErrorMessageMgt.Finish(SalesReceivablesSetup.RecordId);
                SalesReceivablesSetup.Testfield("Posted Prepmt. Cr. Memo Nos.");
                SalesHeader."Prepmt. Cr. Memo No. Series" := SalesReceivablesSetup."Posted Prepmt. Cr. Memo Nos.";
                ModifyHeader := true;
            end;
            SalesHeader.TestField("Prepmt. Cr. Memo No. Series");
            SalesHeader."Prepmt. Cr. Memo No." := NoSeries.GetNextNo(SalesHeader."Prepmt. Cr. Memo No. Series", SalesHeader."Posting Date");
            ModifyHeader := true;
        end;
    end;

    local procedure UpdateInvoiceDocNos(var SalesHeader: Record "Sales Header"; var ModifyHeader: Boolean)
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
        ErrorContextElement: Codeunit "Error Context Element";
    begin
        if GLSetup."Journal Templ. Name Mandatory" then begin
            SalesReceivablesSetup.GetRecordOnce();
            SalesReceivablesSetup.TestField("S. Prep. Inv. Template Name");
            GenJournalTemplate.Get(SalesReceivablesSetup."S. Prep. Inv. Template Name");
            GenJournalTemplate.TestField("Posting No. Series");
            SalesHeader."Prepayment No." := NoSeries.GetNextNo(GenJournalTemplate."Posting No. Series", SalesHeader."Posting Date");
            ModifyHeader := true;
        end else begin
            if SalesHeader."Prepayment No. Series" = '' then begin
                SalesReceivablesSetup.Get();
                ErrorMessageMgt.PushContext(ErrorContextElement, SalesReceivablesSetup.RecordId, 0, '');
                if SalesReceivablesSetup."Posted Prepmt. Inv. Nos." = '' then
                    ErrorMessageMgt.LogContextFieldError(
                        SalesReceivablesSetup.FieldNo("Posted Prepmt. Inv. Nos."), SpecifyInvNoSerieTok,
                        SalesReceivablesSetup.RecordId, SalesReceivablesSetup.FieldNo("Posted Prepmt. Inv. Nos."), '');
                ErrorMessageMgt.Finish(SalesReceivablesSetup.RecordId);
                SalesHeader."Prepayment No. Series" := SalesReceivablesSetup."Posted Prepmt. Inv. Nos.";
                ModifyHeader := true;
            end;
            SalesHeader.TestField("Prepayment No. Series");
            SalesHeader."Prepayment No." := NoSeries.GetNextNo(SalesHeader."Prepayment No. Series", SalesHeader."Posting Date");
            ModifyHeader := true;
        end;
    end;

    local procedure PostBalancingEntry(SalesHeader: Record "Sales Header"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer"; CustLedgEntry: Record "Cust. Ledger Entry"; DocumentType: Option Invoice,"Credit Memo"; PostingDescription: Text[100]; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Text[35]; SrcCode: Code[10]; PostingNoSeriesCode: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."VAT Reporting Date", PostingDescription,
            SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID", SalesHeader."Reason Code");

        if DocType = GenJnlLine."Document Type"::"Credit Memo" then
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::Refund, DocNo, ExtDocNo, SrcCode, PostingNoSeriesCode)
        else
            GenJnlLine.CopyDocumentFields(GenJnlLine."Document Type"::Payment, DocNo, ExtDocNo, SrcCode, PostingNoSeriesCode);

        GenJnlLine.CopyFromSalesHeaderPrepmtPost(SalesHeader, false);
        if SalesHeader."Bal. Account Type" = SalesHeader."Bal. Account Type"::"Bank Account" then
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := SalesHeader."Bal. Account No.";

        // GenJnlLine.Amount := TotalPrepmtInvLineBuffer."Amount Incl. VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        // GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        // if CustLedgEntry.Amount = 0 then
        //     GenJnlLine."Amount (LCY)" := TotalPrepmtInvLineBufferLCY."Amount Incl. VAT"
        // else
        //     GenJnlLine."Amount (LCY)" :=
        //       TotalPrepmtInvLineBufferLCY."Amount Incl. VAT" +
        //       Round(
        //         CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");

        GenJnlLine.Correction := (DocumentType = DocumentType::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

        GenJnlLine."Applies-to Doc. Type" := DocType;
        GenJnlLine."Applies-to Doc. No." := DocNo;
        //rubah ke payment
        GenJnlLine.Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT" + -CustLedgEntry."Remaining Pmt. Disc. Possible";
        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
        if CustLedgEntry.Amount = 0 then
            GenJnlLine."Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT"
        else
            GenJnlLine."Amount (LCY)" :=
              -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT" +
              Round(
                -CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;

        GenJnlLine."Orig. Pmt. Disc. Possible" := TotalPrepmtInvLineBuffer."Orig. Pmt. Disc. Possible";
        GenJnlLine."Orig. Pmt. Disc. Possible(LCY)" := TotalPrepmtInvLineBufferLCY."Orig. Pmt. Disc. Possible";
        if GLSetup."Journal Templ. Name Mandatory" then
            GenJnlLine."Journal Template Name" := GenJournalTemplate.Name;

        Clear(GenJnlLine."Payment Discount %");
        Clear(GenJnlLine."Pmt. Discount Date");
        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;


    local procedure UpdateSalesDocument(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo"; GenJnlLineDocNo: Code[20])
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if DocumentType = DocumentType::Invoice then begin
            SalesHeader."Last Prepayment No." := GenJnlLineDocNo;
            SalesHeader."Prepayment No." := '';
            SalesLine.SetFilter("Prepmt. Line Amount", '<>0');
            if SalesLine.FindSet(true) then
                repeat
                    if SalesLine."Prepmt. Line Amount" <> SalesLine."Prepmt. Amt. Inv." then begin
                        SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
                        SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                        SalesLine.CalcPrepaymentToDeduct();
                        SalesLine."Prepmt VAT Diff. to Deduct" :=
                          SalesLine."Prepmt VAT Diff. to Deduct" + SalesLine."Prepayment VAT Difference";
                        SalesLine."Prepayment VAT Difference" := 0;
                        SalesLine.Modify();
                    end;
                until SalesLine.Next() = 0;
        end else begin
            SalesHeader."Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
            SalesHeader."Prepmt. Cr. Memo No." := '';
            SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
            if SalesLine.FindSet(true) then
                repeat
                    SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt Amt Deducted";
                    if SalesHeader."Prices Including VAT" then
                        SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Inv."
                    else
                        SalesLine."Prepmt. Amount Inv. Incl. VAT" :=
                          Round(
                            SalesLine."Prepmt. Amt. Inv." * (100 + SalesLine."Prepayment VAT %") / 100,
                            GetCurrencyAmountRoundingPrecision(SalesLine."Currency Code"));
                    SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt. Amount Inv. Incl. VAT";
                    SalesLine."Prepayment Amount" := SalesLine."Prepmt. Amt. Inv.";
                    SalesLine."Prepmt Amt to Deduct" := 0;
                    SalesLine."Prepmt VAT Diff. to Deduct" := 0;
                    SalesLine."Prepayment VAT Difference" := 0;
                    SalesLine.Modify();
                until SalesLine.Next() = 0;
        end;

        //SalesHeader."Prepayment %" := SalesHeader."Prepayment %" + (100 / SalesHeader.Termin.AsInteger());
    end;

    local procedure GetCurrencyAmountRoundingPrecision(CurrencyCode: Code[10]): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.Initialize(CurrencyCode);
        Currency.TestField("Amount Rounding Precision");
        exit(Currency."Amount Rounding Precision");
    end;

    local procedure UpdatePostedSalesDocument(DocumentType: Option Invoice,"Credit Memo"; DocumentNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        case DocumentType of
            DocumentType::Invoice:
                begin
                    //update invoice ke payment
                    //CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Payment);
                    CustLedgerEntry.SetRange("Document No.", DocumentNo);
                    CustLedgerEntry.FindFirst();
                    SalesInvoiceHeader.Get(DocumentNo);
                    SalesInvoiceHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesInvoiceHeader.Modify();
                end;
            DocumentType::"Credit Memo":
                begin
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
                    CustLedgerEntry.SetRange("Document No.", DocumentNo);
                    CustLedgerEntry.FindFirst();
                    SalesCrMemoHeader.Get(DocumentNo);
                    SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
                    SalesCrMemoHeader.Modify();
                end;
        end;
    end;

    local procedure AmountToLCY(SalesHeader: Record "Sales Header"; TotalAmt: Decimal; PrevTotalAmt: Decimal): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.Init();
        exit(
            Round(
                CurrExchRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date", SalesHeader."Currency Code", TotalAmt, SalesHeader."Currency Factor")) -
            PrevTotalAmt);
    end;

    local procedure AdjustInvLineBuffers(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo")
    var
        VATAdjustment: array[2] of Decimal;
        VAT: Option ,Base,Amount;
    begin
        CalcPrepmtAmtInvLCYInLines(SalesHeader, PrepmtInvLineBuf, DocumentType, VATAdjustment);
        if Abs(VATAdjustment[VAT::Base]) > GLSetup."Amount Rounding Precision" then
            InsertCorrInvLineBuffer(PrepmtInvLineBuf, SalesHeader, VATAdjustment[VAT::Base])
        else
            if (VATAdjustment[VAT::Base] <> 0) or (VATAdjustment[VAT::Amount] <> 0) then begin
                PrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
                TotalPrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
            end;
    end;

    local procedure CalcPrepmtAmtInvLCYInLines(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo"; var VATAdjustment: array[2] of Decimal)
    var
        SalesLine: Record "Sales Line";
        PrepmtInvBufAmount: array[2] of Decimal;
        TotalAmount: array[2] of Decimal;
        LineAmount: array[2] of Decimal;
        Ratio: array[2] of Decimal;
        PrepmtAmtReminder: array[2] of Decimal;
        PrepmtAmountRnded: array[2] of Decimal;
        VAT: Option ,Base,Amount;
    begin
        PrepmtInvLineBuf.AmountsToArray(PrepmtInvBufAmount);
        if DocumentType = DocumentType::Invoice then
            ReverseDecArray(PrepmtInvBufAmount);

        TempGlobalPrepmtInvLineBuf.SetFilterOnPKey(PrepmtInvLineBuf);
        TempGlobalPrepmtInvLineBuf.CalcSums(Amount, "Amount Incl. VAT");
        TempGlobalPrepmtInvLineBuf.AmountsToArray(TotalAmount);
        for VAT := VAT::Base to VAT::Amount do
            if TotalAmount[VAT] = 0 then
                Ratio[VAT] := 0
            else
                Ratio[VAT] := PrepmtInvBufAmount[VAT] / TotalAmount[VAT];
        if TempGlobalPrepmtInvLineBuf.FindSet() then
            repeat
                TempGlobalPrepmtInvLineBuf.AmountsToArray(LineAmount);
                PrepmtAmountRnded[VAT::Base] :=
                  CalcRoundedAmount(LineAmount[VAT::Base], Ratio[VAT::Base], PrepmtAmtReminder[VAT::Base]);
                PrepmtAmountRnded[VAT::Amount] :=
                  CalcRoundedAmount(LineAmount[VAT::Amount], Ratio[VAT::Amount], PrepmtAmtReminder[VAT::Amount]);

                SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", TempGlobalPrepmtInvLineBuf."Line No.");
                if DocumentType = DocumentType::"Credit Memo" then begin
                    VATAdjustment[VAT::Base] += SalesLine."Prepmt. Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Base];
                    SalesLine."Prepmt. Amount Inv. (LCY)" := 0;
                    VATAdjustment[VAT::Amount] += SalesLine."Prepmt. VAT Amount Inv. (LCY)" - PrepmtAmountRnded[VAT::Amount];
                    SalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
                end else begin
                    SalesLine."Prepmt. Amount Inv. (LCY)" += PrepmtAmountRnded[VAT::Base];
                    SalesLine."Prepmt. VAT Amount Inv. (LCY)" += PrepmtAmountRnded[VAT::Amount];
                end;
                SalesLine.Modify();
            until TempGlobalPrepmtInvLineBuf.Next() = 0;
        TempGlobalPrepmtInvLineBuf.DeleteAll();
    end;

    local procedure ReverseDecArray(var DecArray: array[2] of Decimal)
    var
        Idx: Integer;
    begin
        for Idx := 1 to ArrayLen(DecArray) do
            DecArray[Idx] := -DecArray[Idx];
    end;

    local procedure CalcRoundedAmount(LineAmount: Decimal; Ratio: Decimal; var Reminder: Decimal) RoundedAmount: Decimal
    var
        Amount: Decimal;
    begin
        Amount := Reminder + LineAmount * Ratio;
        RoundedAmount := Round(Amount);
        Reminder := Amount - RoundedAmount;
    end;

    local procedure InsertCorrInvLineBuffer(var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; SalesHeader: Record "Sales Header"; VATBaseAdjustment: Decimal)
    var
        NewPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        SavedPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        AdjmtAmountACY: Decimal;
    begin
        SavedPrepmtInvLineBuf := PrepmtInvLineBuf;

        if SalesHeader."Currency Code" = '' then
            AdjmtAmountACY := VATBaseAdjustment
        else
            AdjmtAmountACY := 0;

        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
          PrepmtInvLineBuf,
          GetPrepmtAccNo(PrepmtInvLineBuf."Gen. Bus. Posting Group", PrepmtInvLineBuf."Gen. Prod. Posting Group"),
          VATBaseAdjustment, AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
          PrepmtInvLineBuf,
          GetCorrBalAccNo(SalesHeader, VATBaseAdjustment > 0),
          -VATBaseAdjustment, -AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

        PrepmtInvLineBuf := SavedPrepmtInvLineBuf;
    end;

    local procedure GetPrepmtAccNo(GenBusPostingGroup: Code[20]; GenProdPostingGroup: Code[20]) PrepmtAccNo: Code[20]
    begin
        if (GenBusPostingGroup <> GenPostingSetup."Gen. Bus. Posting Group") or
           (GenProdPostingGroup <> GenPostingSetup."Gen. Prod. Posting Group")
        then
            GenPostingSetup.Get(GenBusPostingGroup, GenProdPostingGroup);
        PrepmtAccNo := GenPostingSetup.GetSalesPrepmtAccount();

        exit(PrepmtAccNo);
    end;

    procedure GetCorrBalAccNo(SalesHeader: Record "Sales Header"; PositiveAmount: Boolean): Code[20]
    var
        BalAccNo: Code[20];
    begin
        if SalesHeader."Currency Code" = '' then
            BalAccNo := GetInvRoundingAccNo(SalesHeader."Customer Posting Group")
        else
            BalAccNo := GetGainLossGLAcc(SalesHeader."Currency Code", PositiveAmount);

        exit(BalAccNo);
    end;

    procedure GetInvRoundingAccNo(CustomerPostingGroup: Code[20]): Code[20]
    var
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";
    begin
        CustPostingGr.Get(CustomerPostingGroup);
        GLAcc.Get(CustPostingGr.GetInvRoundingAccount());
        exit(CustPostingGr."Invoice Rounding Account");
    end;

    local procedure GetGainLossGLAcc(CurrencyCode: Code[10]; PositiveAmount: Boolean): Code[20]
    var
        Currency: Record Currency;
    begin
        Currency.Get(CurrencyCode);
        if PositiveAmount then
            exit(Currency.GetRealizedGainsAccount());
        exit(Currency.GetRealizedLossesAccount());
    end;

    local procedure InsertSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; PostingDescription: Text[100]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; PostingNoSeriesCode: Code[20])
    begin
        SalesInvHeader.Init();
        SalesInvHeader.TransferFields(SalesHeader);
        SalesInvHeader."Posting Description" := PostingDescription;
        SalesInvHeader."Payment Terms Code" := SalesHeader."Prepmt. Payment Terms Code";
        SalesInvHeader."Due Date" := SalesHeader."Prepayment Due Date";
        SalesInvHeader."Pmt. Discount Date" := SalesHeader."Prepmt. Pmt. Discount Date";
        SalesInvHeader."Payment Discount %" := SalesHeader."Prepmt. Payment Discount %";
        SalesInvHeader."No." := GenJnlLineDocNo;
        SalesInvHeader."Pre-Assigned No. Series" := '';
        SalesInvHeader."Source Code" := SrcCode;
        SalesInvHeader."User ID" := CopyStr(UserId(), 1, MaxStrLen(SalesInvHeader."User ID"));
        SalesInvHeader."No. Printed" := 0;
        SalesInvHeader."Prepayment Invoice" := true;
        SalesInvHeader."Prepayment Order No." := SalesHeader."No.";
        SalesInvHeader."No. Series" := PostingNoSeriesCode;
        SalesInvHeader.Insert();
        CopyHeaderCommentLines(SalesHeader."No.", Database::"Sales Invoice Header", GenJnlLineDocNo);
    end;

    local procedure CopyHeaderCommentLines(FromNumber: Code[20]; ToDocType: Integer; ToNumber: Code[20])
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        if not SalesSetup."Copy Comments Order to Invoice" then
            exit;

        case ToDocType of
            Database::"Sales Invoice Header":
                SalesCommentLine.CopyHeaderComments(
                    SalesCommentLine."Document Type"::Order.AsInteger(), SalesCommentLine."Document Type"::"Posted Invoice".AsInteger(),
                    FromNumber, ToNumber);
            Database::"Sales Cr.Memo Header":
                SalesCommentLine.CopyHeaderComments(
                    SalesCommentLine."Document Type"::Order.AsInteger(), SalesCommentLine."Document Type"::"Posted Credit Memo".AsInteger(),
                    FromNumber, ToNumber);
        end;
    end;

    local procedure GetCalcPmtDiscOnCrMemos(PrepmtPmtTermsCode: Code[10]): Boolean
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PrepmtPmtTermsCode = '' then
            exit(false);
        PaymentTerms.Get(PrepmtPmtTermsCode);
        exit(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
    end;

    local procedure InsertSalesCrMemoHeader(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; PostingDescription: Text[100]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; PostingNoSeriesCode: Code[20]; CalcPmtDiscOnCrMemos: Boolean)
    begin
        SalesCrMemoHeader.Init();
        SalesCrMemoHeader.TransferFields(SalesHeader);
        SalesCrMemoHeader."Payment Terms Code" := SalesHeader."Prepmt. Payment Terms Code";
        SalesCrMemoHeader."Pmt. Discount Date" := SalesHeader."Prepmt. Pmt. Discount Date";
        SalesCrMemoHeader."Payment Discount %" := SalesHeader."Prepmt. Payment Discount %";
        if (SalesHeader."Prepmt. Payment Terms Code" <> '') and not CalcPmtDiscOnCrMemos then begin
            SalesCrMemoHeader."Payment Discount %" := 0;
            SalesCrMemoHeader."Pmt. Discount Date" := 0D;
        end;
        SalesCrMemoHeader."Posting Description" := PostingDescription;
        SalesCrMemoHeader."Due Date" := SalesHeader."Prepayment Due Date";
        SalesCrMemoHeader."No." := GenJnlLineDocNo;
        SalesCrMemoHeader."Pre-Assigned No. Series" := '';
        SalesCrMemoHeader."Source Code" := SrcCode;
        SalesCrMemoHeader."User ID" := CopyStr(UserId(), 1, MaxStrLen(SalesCrMemoHeader."User ID"));
        SalesCrMemoHeader."No. Printed" := 0;
        SalesCrMemoHeader."Prepayment Credit Memo" := true;
        SalesCrMemoHeader."Prepayment Order No." := SalesHeader."No.";
        SalesCrMemoHeader.Correction := GLSetup."Mark Cr. Memos as Corrections";
        SalesCrMemoHeader."No. Series" := PostingNoSeriesCode;
        SalesCrMemoHeader.Insert();
        CopyHeaderCommentLines(SalesHeader."No.", Database::"Sales Cr.Memo Header", GenJnlLineDocNo);
    end;

    procedure GetSalesLinesToDeduct(SalesHeader: Record "Sales Header"; var SalesLines: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
    begin
        ApplyFilter(SalesHeader, 1, SalesLine);
        if SalesLine.FindSet() then
            repeat
                if (PrepmtAmount(SalesLine, 0) <> 0) and (PrepmtAmount(SalesLine, 1) <> 0) then begin
                    SalesLines := SalesLine;
                    SalesLines.Insert();
                end;
            until SalesLine.Next() = 0;
    end;

    procedure ApplyFilter(SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo",Statistic; var SalesLine: Record "Sales Line")
    begin
        SalesLine.Reset();
        SalesLine.SetFilter("Document Type", '%1', SalesHeader."Document Type"::"Blanket Order");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if DocumentType in [DocumentType::Invoice, DocumentType::Statistic] then
            SalesLine.SetFilter("Prepmt. Line Amount", '<>0')
        else
            SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
    end;

    procedure PrepmtAmount(SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo",Statistic) Result: Decimal
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

        case DocumentType of
            DocumentType::Statistic:
                exit(SalesLine."Prepmt. Line Amount");
            DocumentType::Invoice:
                exit(SalesLine."Prepmt. Line Amount" - SalesLine."Prepmt. Amt. Inv.");
            else
                exit(SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");
        end;
    end;

    procedure CalcVATAmountLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        Currency: Record Currency;
        NewAmount: Decimal;
        NewPrepmtVATDiffAmt: Decimal;
        IsHandled: Boolean;
    begin
        GLSetup.GetRecordOnce();
        Currency.Initialize(SalesHeader."Currency Code");

        VATAmountLine.DeleteAll();

        ApplyFilter(SalesHeader, DocumentType, SalesLine);
        if SalesLine.Find('-') then
            repeat
                NewAmount := PrepmtAmount(SalesLine, DocumentType);
                if NewAmount <> 0 then begin
                    if DocumentType = DocumentType::Invoice then
                        NewAmount := SalesLine."Prepmt. Line Amount";
                    if SalesLine."Prepmt. VAT Calc. Type" in
                       [SalesLine."VAT Calculation Type"::"Reverse Charge VAT", SalesLine."VAT Calculation Type"::"Sales Tax"]
                    then
                        SalesLine."VAT %" := 0;

                    if not FindVATAmountLine(SalesLine, VATAmountLine, NewAmount) then
                        InsertVATAmountLine(SalesLine, VATAmountLine, NewAmount);

                    VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
                    NewPrepmtVATDiffAmt := PrepmtVATDiffAmount(SalesLine, DocumentType);
                    if DocumentType = DocumentType::Invoice then
                        NewPrepmtVATDiffAmt := SalesLine."Prepayment VAT Difference" + SalesLine."Prepmt VAT Diff. to Deduct" +
                          SalesLine."Prepmt VAT Diff. Deducted";
                    VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + NewPrepmtVATDiffAmt;
                    VATAmountLine.Modify();
                end;
            until SalesLine.Next() = 0;
        VATAmountLine.Reset();

        IsHandled := false;
        if not IsHandled then
            VATAmountLine.UpdateLines(
              NewAmount, Currency, SalesHeader."Currency Factor", SalesHeader."Prices Including VAT",
              SalesHeader."VAT Base Discount %", SalesHeader."Tax Area Code", SalesHeader."Tax Liable", SalesHeader."Posting Date");
    end;

    local procedure PrepmtVATDiffAmount(SalesLine: Record "Sales Line"; DocumentType: Option Invoice,"Credit Memo",Statistic): Decimal
    begin
        case DocumentType of
            DocumentType::Statistic:
                exit(SalesLine."Prepayment VAT Difference");
            DocumentType::Invoice:
                exit(SalesLine."Prepayment VAT Difference");
            else
                exit(SalesLine."Prepmt VAT Diff. to Deduct");
        end;
    end;

    local procedure InsertVATAmountLine(var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; LineAmount: Decimal)
    begin
        VATAmountLine.Init();
        VATAmountLine."VAT Identifier" := SalesLine."Prepayment VAT Identifier";
        VATAmountLine."VAT Calculation Type" := SalesLine."Prepmt. VAT Calc. Type";
        VATAmountLine."Tax Group Code" := SalesLine."Prepayment Tax Group Code";
        VATAmountLine."VAT %" := SalesLine."Prepayment VAT %";
        VATAmountLine.Positive := LineAmount >= 0;
        VATAmountLine.Modified := true;
        VATAmountLine."Includes Prepayment" := true;
        VATAmountLine.Insert();
    end;

    local procedure FindVATAmountLine(var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line" temporary; LineAmount: Decimal): Boolean
    begin
        VATAmountLine.Reset();
        VATAmountLine.SetRange("VAT Identifier", SalesLine."Prepayment VAT Identifier");
        VATAmountLine.SetRange("VAT Calculation Type", SalesLine."Prepmt. VAT Calc. Type");
        VATAmountLine.SetRange("Tax Group Code", SalesLine."Prepayment Tax Group Code");
        VATAmountLine.SetRange("Use Tax", false);
        VATAmountLine.SetRange(Positive, LineAmount >= 0);
        exit(VATAmountLine.FindFirst());
    end;

    procedure UpdateVATOnLines(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        PrepmtAmt: Decimal;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        NewPmtDiscAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        PrepmtAmtToInvTotal: Decimal;
        RemainderExists: Boolean;
    begin
        GLSetup.GetRecordOnce();
        Currency.Initialize(SalesHeader."Currency Code");

        ApplyFilter(SalesHeader, DocumentType, SalesLine);
        SalesLine.LockTable();
        SalesLine.CalcSums("Prepmt. Line Amount", "Prepmt. Amt. Inv.");
        PrepmtAmtToInvTotal := SalesLine."Prepmt. Line Amount" - SalesLine."Prepmt. Amt. Inv.";
        if SalesLine.FindSet() then
            repeat
                PrepmtAmt := PrepmtAmount(SalesLine, DocumentType);
                if PrepmtAmt <> 0 then begin
                    FindVATAmountLine(SalesLine, VATAmountLine, PrepmtAmt);
                    if VATAmountLine.Modified then begin
                        RemainderExists :=
                          FindVATAmountLine(SalesLine, TempVATAmountLineRemainder, PrepmtAmt);
                        if not RemainderExists then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init();
                            TempVATAmountLineRemainder.Insert();
                        end;

                        if SalesHeader."Prices Including VAT" then begin
                            if PrepmtAmt = 0 then begin
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            end else begin
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" * PrepmtAmt / VATAmountLine."Line Amount";
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" * PrepmtAmt / VATAmountLine."Line Amount";
                            end;
                            NewAmount :=
                              Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              Round(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              Round(
                                NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                        end else begin
                            if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then begin
                                VATAmount := PrepmtAmt;
                                NewAmount := 0;
                                NewVATBaseAmount := 0;
                            end else begin
                                NewAmount := PrepmtAmt;
                                NewVATBaseAmount :=
                                  Round(
                                    NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision");
                                if VATAmountLine."VAT Base" = 0 then
                                    VATAmount := 0
                                else
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            end;
                            NewAmountIncludingVAT := NewAmount + Round(VATAmount, Currency."Amount Rounding Precision");
                        end;

                        SalesLine."Prepayment Amount" := NewAmount;
                        SalesLine."Prepmt. Amt. Incl. VAT" :=
                          Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        SalesLine."Prepmt. VAT Base Amt." := NewVATBaseAmount;

                        if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 then
                            VATDifference := 0
                        else begin
                            if PrepmtAmtToInvTotal = 0 then
                                VATDifference :=
                                  VATAmountLine."VAT Difference" * (SalesLine."Prepmt. Line Amount" - SalesLine."Prepmt. Amt. Inv.") /
                                  (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount")
                            else
                                VATDifference :=
                                  VATAmountLine."VAT Difference" * (SalesLine."Prepmt. Line Amount" - SalesLine."Prepmt. Amt. Inv.") /
                                  PrepmtAmtToInvTotal;
                            NewPmtDiscAmount :=
                              TempVATAmountLineRemainder."Pmt. Discount Amount" +
                              NewAmount * SalesHeader."Payment Discount %" / 100;
                        end;

                        SalesLine."Prepayment VAT Difference" := Round(VATDifference, Currency."Amount Rounding Precision");
                        SalesLine."Prepmt. Pmt. Discount Amount" := Round(NewPmtDiscAmount, Currency."Amount Rounding Precision");
                        SalesLine.Modify();

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder."VAT Difference" := VATDifference - SalesLine."Prepayment VAT Difference";
                        TempVATAmountLineRemainder."Pmt. Discount Amount" := NewPmtDiscAmount - Round(NewPmtDiscAmount);
                        TempVATAmountLineRemainder.Modify();
                    end;
                end;
            until SalesLine.Next() = 0;
        VATAmountLine.Reset();

    end;

    local procedure BuildInvLineBuffer(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option; var TempPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer" temporary; UpdateLines: Boolean)
    var
        PrepmtInvLineBuf2: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferDummy: Record "Prepayment Inv. Line Buffer";
    begin
        TempGlobalPrepmtInvLineBuf.Reset();
        TempGlobalPrepmtInvLineBuf.DeleteAll();
        TempSalesLine.Reset();
        TempSalesLine.DeleteAll();
        SalesSetup.Get();
        ApplyFilter(SalesHeader, DocumentType, SalesLine);
        if SalesLine.Find('-') then
            repeat
                if PrepmtAmount(SalesLine, DocumentType) <> 0 then begin
                    if not CheckSystemCreatedInvoiceRoundEntry(SalesLine, SalesHeader."Customer Posting Group") then
                        CheckSalesLineIsNegative(SalesHeader, SalesLine);

                    FillInvLineBuffer(SalesHeader, SalesLine, PrepmtInvLineBuf2);
                    if UpdateLines then
                        TempGlobalPrepmtInvLineBuf.CopyWithLineNo(PrepmtInvLineBuf2, SalesLine."Line No.");
                    TempPrepmtInvLineBuf.InsertInvLineBuffer(PrepmtInvLineBuf2);
                    if SalesSetup."Invoice Rounding" then
                        RoundAmounts(SalesHeader, PrepmtInvLineBuf2, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferDummy);
                    TempSalesLine := SalesLine;
                    TempSalesLine.Insert();
                end;
            until SalesLine.Next() = 0;
        if SalesSetup."Invoice Rounding" then
            if InsertInvoiceRounding(
                 SalesHeader, PrepmtInvLineBuf2, TotalPrepmtInvLineBuffer, SalesLine."Line No.")
            then
                TempPrepmtInvLineBuf.InsertInvLineBuffer(PrepmtInvLineBuf2);
        ErrorMessageMgt.FinishTopContext();
    end;

    local procedure InsertInvoiceRounding(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; PrevLineNo: Integer): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        if InitInvoiceRoundingLine(SalesHeader, TotalPrepmtInvLineBuf."Amount Incl. VAT", SalesLine) then begin
            CreateDimensions(SalesLine);
            PrepmtInvLineBuf.Init();
            PrepmtInvLineBuf."Line No." := PrevLineNo + 10000;
            PrepmtInvLineBuf."Invoice Rounding" := true;
            PrepmtInvLineBuf."G/L Account No." := SalesLine."No.";
            PrepmtInvLineBuf.Description := SalesLine.Description;

            PrepmtInvLineBuf.CopyFromSalesLine(SalesLine);
            PrepmtInvLineBuf."Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
            PrepmtInvLineBuf."VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";

            PrepmtInvLineBuf.SetAmounts(
              SalesLine."Line Amount", SalesLine."Amount Including VAT", SalesLine."Line Amount",
              SalesLine."Prepayment Amount", SalesLine."Line Amount", 0);

            PrepmtInvLineBuf."VAT Amount" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
            PrepmtInvLineBuf."VAT Amount (ACY)" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
            exit(true);
        end;
    end;

    procedure InitInvoiceRoundingLine(SalesHeader: Record "Sales Header"; TotalAmount: Decimal; var SalesLine: Record "Sales Line"): Boolean
    var
        Currency: Record Currency;
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -Round(
            TotalAmount -
            Round(
              TotalAmount,
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection()),
            Currency."Amount Rounding Precision");

        if InvoiceRoundingAmount = 0 then
            exit(false);

        SalesLine.SetHideValidationDialog(true);
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."System-Created Entry" := true;
        SalesLine.Type := SalesLine.Type::"G/L Account";
        SalesLine.Validate("No.", GetInvRoundingAccNo(SalesHeader."Customer Posting Group"));
        SalesLine.Validate(Quantity, 1);
        if SalesHeader."Prices Including VAT" then
            SalesLine.Validate("Unit Price", InvoiceRoundingAmount)
        else
            SalesLine.Validate(
              "Unit Price",
              Round(
                InvoiceRoundingAmount /
                (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * SalesLine."VAT %" / 100),
                Currency."Amount Rounding Precision"));
        SalesLine."Prepayment Amount" := SalesLine."Unit Price";
        SalesLine.Validate("Amount Including VAT", InvoiceRoundingAmount);
        exit(true);
    end;

    local procedure CreateDimensions(var SalesLine: Record "Sales Line")
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        SourceCodeSetup.Get();
        DimMgt.AddDimSource(DefaultDimSource, Database::"G/L Account", SalesLine."No.");
        DimMgt.AddDimSource(DefaultDimSource, Database::Job, SalesLine."Job No.");
        DimMgt.AddDimSource(DefaultDimSource, Database::"Responsibility Center", SalesLine."Responsibility Center");
        SalesLine."Shortcut Dimension 1 Code" := '';
        SalesLine."Shortcut Dimension 2 Code" := '';
        SalesLine."Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            SalesLine, 0, DefaultDimSource, SourceCodeSetup.Sales,
            SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code", SalesLine."Dimension Set ID", Database::Customer);
    end;

    local procedure CreateLinesFromBuffer(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary; var SalesInvHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var PrevLineNo: Integer; var LineCount: Integer; var PostedDocTabNo: Integer; var LineNo: Integer; DocumentType: Option Invoice,"Credit Memo"; var Window: Dialog; GenJnlLineDocNo: Code[20])
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        TempPrepmtInvLineBuffer.Find('-');
        repeat
            LineCount := LineCount + 1;
            LineNo := PrevLineNo + 10000;
            case DocumentType of
                DocumentType::Invoice:
                    begin
                        InsertSalesInvLine(SalesInvHeader, LineNo, TempPrepmtInvLineBuffer, SalesHeader);
                        PostedDocTabNo := Database::"Sales Invoice Line";
                    end;
                DocumentType::"Credit Memo":
                    begin
                        InsertSalesCrMemoLine(SalesCrMemoHeader, LineNo, TempPrepmtInvLineBuffer, SalesHeader);
                        PostedDocTabNo := Database::"Sales Cr.Memo Line";
                    end;
            end;
            PrevLineNo := LineNo;
            InsertExtendedText(PostedDocTabNo, GenJnlLineDocNo, TempPrepmtInvLineBuffer."G/L Account No.", SalesHeader."Document Date", SalesHeader."Language Code", PrevLineNo, SalesHeader);
        until TempPrepmtInvLineBuffer.Next() = 0;
    end;

    local procedure InsertSalesInvLine(SalesInvHeader: Record "Sales Invoice Header"; LineNo: Integer; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; SalesHeader: Record "Sales Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        VATPostingSetup: Record "VAT Posting Setup";
        SalesLine: Record "Sales Line";
    begin
        SalesInvLine.Init();
        SalesInvLine."Document No." := SalesInvHeader."No.";
        SalesInvLine."Line No." := LineNo;
        SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
        SalesInvLine.Type := SalesInvLine.Type::"G/L Account";
        SalesInvLine."No." := PrepmtInvLineBuffer."G/L Account No.";
        SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
        SalesInvLine."Shortcut Dimension 1 Code" := PrepmtInvLineBuffer."Global Dimension 1 Code";
        SalesInvLine."Shortcut Dimension 2 Code" := PrepmtInvLineBuffer."Global Dimension 2 Code";
        SalesInvLine."Dimension Set ID" := PrepmtInvLineBuffer."Dimension Set ID";
        SalesInvLine.Description := PrepmtInvLineBuffer.Description;
        if not SalesHeader."Compress Prepayment" then
            if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", PrepmtInvLineBuffer."Line No.") then
                SalesInvLine."Description 2" := SalesLine."Description 2";

        if SalesHeader."Compress Prepayment" then
            if SalesLine.Get(SalesHeader."Document Type", SalesHeader."No.", LineNo) then
                SalesInvLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";

        SalesInvLine.Quantity := 1;
        if SalesInvHeader."Prices Including VAT" then begin
            SalesInvLine."Unit Price" := PrepmtInvLineBuffer."Amount Incl. VAT";
            SalesInvLine."Line Amount" := PrepmtInvLineBuffer."Amount Incl. VAT";
        end else begin
            SalesInvLine."Unit Price" := PrepmtInvLineBuffer.Amount;
            SalesInvLine."Line Amount" := PrepmtInvLineBuffer.Amount;
        end;
        SalesInvLine."Gen. Bus. Posting Group" := PrepmtInvLineBuffer."Gen. Bus. Posting Group";
        SalesInvLine."Gen. Prod. Posting Group" := PrepmtInvLineBuffer."Gen. Prod. Posting Group";
        SalesInvLine."VAT Bus. Posting Group" := PrepmtInvLineBuffer."VAT Bus. Posting Group";
        SalesInvLine."VAT Prod. Posting Group" := PrepmtInvLineBuffer."VAT Prod. Posting Group";
        SalesInvLine."VAT %" := PrepmtInvLineBuffer."VAT %";
        if VATPostingSetup.GET(PrepmtInvLineBuffer."VAT Bus. Posting Group", PrepmtInvLineBuffer."VAT Prod. Posting Group") then
            SalesInvLine."VAT Clause Code" := VATPostingSetup."VAT Clause Code";
        SalesInvLine.Amount := PrepmtInvLineBuffer.Amount;
        SalesInvLine."VAT Difference" := PrepmtInvLineBuffer."VAT Difference";
        SalesInvLine."Amount Including VAT" := PrepmtInvLineBuffer."Amount Incl. VAT";
        SalesInvLine."VAT Calculation Type" := PrepmtInvLineBuffer."VAT Calculation Type";
        SalesInvLine."VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount";
        SalesInvLine."VAT Identifier" := PrepmtInvLineBuffer."VAT Identifier";
        SalesInvLine."Pmt. Discount Amount" := PrepmtInvLineBuffer."Orig. Pmt. Disc. Possible";
        SalesInvLine.Insert();
    end;

    local procedure InsertSalesCrMemoLine(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; LineNo: Integer; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; SalesHeader: Record "Sales Header")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        SalesCrMemoLine.Init();
        SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
        SalesCrMemoLine."Line No." := LineNo;
        SalesCrMemoLine."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
        SalesCrMemoLine."Bill-to Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
        SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
        SalesCrMemoLine."No." := PrepmtInvLineBuffer."G/L Account No.";
        SalesCrMemoLine."Posting Date" := SalesCrMemoHeader."Posting Date";
        SalesCrMemoLine."Shortcut Dimension 1 Code" := PrepmtInvLineBuffer."Global Dimension 1 Code";
        SalesCrMemoLine."Shortcut Dimension 2 Code" := PrepmtInvLineBuffer."Global Dimension 2 Code";
        SalesCrMemoLine."Dimension Set ID" := PrepmtInvLineBuffer."Dimension Set ID";
        SalesCrMemoLine.Description := PrepmtInvLineBuffer.Description;
        SalesCrMemoLine.Quantity := 1;
        if SalesCrMemoHeader."Prices Including VAT" then begin
            SalesCrMemoLine."Unit Price" := PrepmtInvLineBuffer."Amount Incl. VAT";
            SalesCrMemoLine."Line Amount" := PrepmtInvLineBuffer."Amount Incl. VAT";
        end else begin
            SalesCrMemoLine."Unit Price" := PrepmtInvLineBuffer.Amount;
            SalesCrMemoLine."Line Amount" := PrepmtInvLineBuffer.Amount;
        end;
        SalesCrMemoLine."Gen. Bus. Posting Group" := PrepmtInvLineBuffer."Gen. Bus. Posting Group";
        SalesCrMemoLine."Gen. Prod. Posting Group" := PrepmtInvLineBuffer."Gen. Prod. Posting Group";
        SalesCrMemoLine."VAT Bus. Posting Group" := PrepmtInvLineBuffer."VAT Bus. Posting Group";
        SalesCrMemoLine."VAT Prod. Posting Group" := PrepmtInvLineBuffer."VAT Prod. Posting Group";
        SalesCrMemoLine."VAT %" := PrepmtInvLineBuffer."VAT %";
        if VATPostingSetup.GET(PrepmtInvLineBuffer."VAT Bus. Posting Group", PrepmtInvLineBuffer."VAT Prod. Posting Group") then
            SalesCrMemoLine."VAT Clause Code" := VATPostingSetup."VAT Clause Code";
        SalesCrMemoLine.Amount := PrepmtInvLineBuffer.Amount;
        SalesCrMemoLine."VAT Difference" := PrepmtInvLineBuffer."VAT Difference";
        SalesCrMemoLine."Amount Including VAT" := PrepmtInvLineBuffer."Amount Incl. VAT";
        SalesCrMemoLine."VAT Calculation Type" := PrepmtInvLineBuffer."VAT Calculation Type";
        SalesCrMemoLine."VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount";
        SalesCrMemoLine."VAT Identifier" := PrepmtInvLineBuffer."VAT Identifier";
        SalesCrMemoLine."Pmt. Discount Amount" := PrepmtInvLineBuffer."Orig. Pmt. Disc. Possible";
        SalesCrMemoLine.Insert();
        if not SalesHeader."Compress Prepayment" then
            CopyLineCommentLines(
              SalesHeader."No.", Database::"Sales Cr.Memo Header", SalesCrMemoHeader."No.", PrepmtInvLineBuffer."Line No.", LineNo);
    end;

    local procedure CopyLineCommentLines(FromNumber: Code[20]; ToDocType: Integer; ToNumber: Code[20]; FromLineNo: Integer; ToLineNo: Integer)
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        if not SalesSetup."Copy Comments Order to Invoice" then
            exit;

        case ToDocType of
            Database::"Sales Invoice Header":
                SalesCommentLine.CopyLineComments(
                    SalesCommentLine."Document Type"::Order.AsInteger(), SalesCommentLine."Document Type"::"Posted Invoice".AsInteger(),
                    FromNumber, ToNumber, FromLineNo, ToLineNo);
            Database::"Sales Cr.Memo Header":
                SalesCommentLine.CopyLineComments(
                    SalesCommentLine."Document Type"::Order.AsInteger(), SalesCommentLine."Document Type"::"Posted Credit Memo".AsInteger(),
                    FromNumber, ToNumber, FromLineNo, ToLineNo);
        end;
    end;

    local procedure PostPrepmtInvLineBuffer(SalesHeader: Record "Sales Header"; PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; DocumentType: Option Invoice,"Credit Memo"; PostingDescription: Text[100]; DocType: Enum "Gen. Journal Document Type"; DocNo: Code[20]; ExtDocNo: Text[35]; SrcCode: Code[10]; PostingNoSeriesCode: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.InitNewLine(
            SalesHeader."Posting Date", SalesHeader."Document Date", SalesHeader."VAT Reporting Date", PostingDescription,
            PrepmtInvLineBuffer."Global Dimension 1 Code", PrepmtInvLineBuffer."Global Dimension 2 Code",
            PrepmtInvLineBuffer."Dimension Set ID", SalesHeader."Reason Code");

        GenJnlLine.CopyDocumentFields(DocType, DocNo, ExtDocNo, SrcCode, PostingNoSeriesCode);
        GenJnlLine.CopyFromSalesHeaderPrepmt(SalesHeader);
        GenJnlLine.CopyFromPrepmtInvoiceBuffer(PrepmtInvLineBuffer);

        if not PrepmtInvLineBuffer.Adjustment then
            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::Sale;
        GenJnlLine.Correction :=
          (DocumentType = DocumentType::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

        if GLSetup."Journal Templ. Name Mandatory" then
            GenJnlLine."Journal Template Name" := GenJournalTemplate.Name;

        //update invoice ke payment
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine.Amount := -GenJnlLine.Amount;

        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;

    local procedure CheckSystemCreatedInvoiceRoundEntry(SalesLine: Record "Sales Line"; CustomerPostingGroupCode: Code[20]): Boolean
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if (SalesLine.Type <> SalesLine.Type::"G/L Account") or (not SalesLine."System-Created Entry") then
            exit(false);

        if CustomerPostingGroupCode = '' then
            exit(false);

        CustomerPostingGroup.SetLoadFields("Invoice Rounding Account");
        if not CustomerPostingGroup.Get(CustomerPostingGroupCode) then
            exit(false);

        if CustomerPostingGroup."Invoice Rounding Account" = '' then
            exit(false);

        if SalesLine."No." = CustomerPostingGroup."Invoice Rounding Account" then
            exit(true);
    end;

    local procedure CheckSalesLineIsNegative(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if SalesLine.Quantity < 0 then
            SalesLine.FieldError(Quantity, StrSubstNo(Text018, SalesHeader.FieldCaption("Prepayment %")));
        if SalesLine."Unit Price" < 0 then
            SalesLine.FieldError("Unit Price", StrSubstNo(Text018, SalesHeader.FieldCaption("Prepayment %")));
    end;

    procedure FillInvLineBuffer(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer")
    begin
        PrepmtInvLineBuf.Init();
        PrepmtInvLineBuf."G/L Account No." := GetPrepmtAccNo(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");

        if not SalesHeader."Compress Prepayment" then begin
            PrepmtInvLineBuf."Line No." := SalesLine."Line No.";
            PrepmtInvLineBuf.Description := SalesLine.Description;
        end;

        PrepmtInvLineBuf.CopyFromSalesLine(SalesLine);
        PrepmtInvLineBuf.FillFromGLAcc(SalesHeader."Compress Prepayment");

        PrepmtInvLineBuf.SetAmounts(
          SalesLine."Prepayment Amount", SalesLine."Prepmt. Amt. Incl. VAT", SalesLine."Prepayment Amount",
          SalesLine."Prepayment Amount", SalesLine."Prepayment Amount", SalesLine."Prepayment VAT Difference");

        PrepmtInvLineBuf."VAT Amount" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
        PrepmtInvLineBuf."VAT Amount (ACY)" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
        PrepmtInvLineBuf."VAT Base Before Pmt. Disc." := -SalesLine."Prepayment Amount";
        PrepmtInvLineBuf."Orig. Pmt. Disc. Possible" := SalesLine."Prepmt. Pmt. Discount Amount";

    end;

    local procedure InsertExtendedText(TabNo: Integer; DocNo: Code[20]; GLAccNo: Code[20]; DocDate: Date; LanguageCode: Code[10]; var PrevLineNo: Integer; var SalesHeader: Record "Sales Header")
    var
        TempExtTextLine: Record "Extended Text Line" temporary;
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
    begin
        TransferExtText.PrepmtGetAnyExtText(GLAccNo, TabNo, DocDate, LanguageCode, TempExtTextLine);
        if TempExtTextLine.Find('-') then begin
            NextLineNo := PrevLineNo + 10000;
            repeat
                case TabNo of
                    Database::"Sales Invoice Line":
                        begin
                            SalesInvLine.Init();
                            SalesInvLine."Document No." := DocNo;
                            SalesInvLine."Line No." := NextLineNo;
                            SalesInvLine.Description := TempExtTextLine.Text;
                            SalesInvLine.Insert();
                        end;
                    Database::"Sales Cr.Memo Line":
                        begin
                            SalesCrMemoLine.Init();
                            SalesCrMemoLine."Document No." := DocNo;
                            SalesCrMemoLine."Line No." := NextLineNo;
                            SalesCrMemoLine.Description := TempExtTextLine.Text;
                            SalesCrMemoLine.Insert();
                        end;
                end;
                PrevLineNo := NextLineNo;
                NextLineNo := NextLineNo + 10000;
            until TempExtTextLine.Next() = 0;
        end;
    end;

    procedure CheckPrepmtDoc(SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo")
    var
        Cust: Record Customer;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        CheckDimensions: Codeunit "Check Dimensions";
        ForwardLinkMgt: codeunit "Forward Link Mgt.";
        ErrorContextElement: Codeunit "Error Context Element";
        SetupRecID: RecordID;
    begin

        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::"Blanket Order");
        SalesHeader.TestField("Sell-to Customer No.");
        SalesHeader.TestField("Bill-to Customer No.");
        SalesHeader.TestField("Posting Date");
        SalesHeader.TestField("Document Date");
        GLSetup.GetRecordOnce();
        if GLSetup."Journal Templ. Name Mandatory" then
            SalesHeader.TestField("Journal Templ. Name");
        ErrorMessageMgt.PushContext(ErrorContextElement, SalesHeader.RecordId, 0, '');
        if GenJnlCheckLine.DateNotAllowed(SalesHeader."Posting Date", SalesHeader."Journal Templ. Name") then
            ErrorMessageMgt.LogContextFieldError(
              SalesHeader.FieldNo("Posting Date"), StrSubstNo(PostingDateNotAllowedErr, SalesHeader.FieldCaption("Posting Date")),
              SetupRecID, ErrorMessageMgt.GetFieldNo(SetupRecID.TableNo, ''),
              ForwardLinkMgt.GetHelpCodeForAllowedPostingDate());

        if not CheckOpenPrepaymentLines(SalesHeader, DocumentType) then
            Error(DocumentErrorsMgt.GetNothingToPostErrorMsg());

        CheckDimensions.CheckSalesPrepmtDim(SalesHeader);

        SalesHeader.CheckSalesPostRestrictions();
        Cust.Get(SalesHeader."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Enum::"Sales Document Type".FromInteger(PrepmtDocTypeToDocType(DocumentType)), false, true);
        if SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then begin
            Cust.Get(SalesHeader."Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust, Enum::"Sales Document Type".FromInteger(PrepmtDocTypeToDocType(DocumentType)), false, true);
        end;
        ErrorMessageMgt.Finish(SalesHeader.RecordId);
    end;

    procedure CheckOpenPrepaymentLines(SalesHeader: Record "Sales Header"; DocumentType: Option) Found: Boolean
    var
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Found);

        ApplyFilter(SalesHeader, DocumentType, SalesLine);
        if SalesLine.Find('-') then
            repeat
                if not Found then
                    Found := PrepmtAmount(SalesLine, DocumentType) <> 0;
                if SalesLine."Prepmt. Amt. Inv." = 0 then begin
                    SalesLine.UpdatePrepmtSetupFields();
                    SalesLine.Modify();
                end;
            until SalesLine.Next() = 0;
        exit(Found);
    end;

    procedure PrepmtDocTypeToDocType(DocumentType: Option Invoice,"Credit Memo"): Integer
    begin
        case DocumentType of
            DocumentType::Invoice:
                exit(2);
            DocumentType::"Credit Memo":
                exit(3);
        end;
        exit(2);
    end;

    local procedure updateprepayment(var SH: Record "Sales Header"; Line: Record MiiTabScheduleLine)
    var
        SalesLine: Record "Sales Line";
    begin
        SH.CalcFields(Amount);
        SH."Prepayment %" += (Line.Amount / SH.Amount) * 100;
        SH.Validate("Prepayment %");
        SH.Modify();
        Commit();
        SalesLine.SetFilter("Document No.", Line."Document No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Blanket Order");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then begin
            SalesLine."Prepayment %" := SH."Prepayment %";
            SalesLine.Validate("Prepayment %");
            SalesLine.Modify();
        end;
    end;


    // local procedure GetCurrencyAmountRoundingPrecision(CurrencyCode: Code[10]): Decimal
    // var
    //     Currency: Record Currency;
    // begin
    //     Currency.Initialize(CurrencyCode);
    //     Currency.TestField("Amount Rounding Precision");
    //     exit(Currency."Amount Rounding Precision");
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 442, 'OnBeforeCheckPrepmtDoc', '', false, false)]
    // local procedure Editorder(SalesHeader: Record "Sales Header"; DocumentType: Option; CommitIsSuppressed: Boolean)
    // var
    // begin
    //     SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
    //     SalesHeader.Modify();
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 442, 'OnAfterCheckPrepmtDoc', '', false, false)]
    // local procedure EditBlanket(SalesHeader: Record "Sales Header"; DocumentType: Option Invoice,"Credit Memo"; CommitIsSuppressed: Boolean; var ErrorMessageMgt: Codeunit "Error Message Management")
    // var
    // begin
    //     SalesHeader."Document Type" := SalesHeader."Document Type"::"Blanket Order";
    //     SalesHeader.Modify();
    // end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeThrowWrongAmountError', '', false, false)]
    local procedure Makeorder(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
    begin
        //if SalesLine."Document Type" = SalesLine."Document Type"::"Blanket Order" then begin
        IsHandled := true;
        //end;
    end;


    [EventSubscriber(ObjectType::table, 37, 'OnBeforeUpdatePrepmtSetupFields', '', false, false)]
    local procedure EditBlanket(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    var
        GLAcc: Record "G/L Account";
    begin
        IsHandled := true;
        if GenPostingSetup."Sales Prepayments Account" <> '' then begin
            GLAcc.Get(GenPostingSetup."Sales Prepayments Account");
            VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
            VATPostingSetup.TestField("VAT Calculation Type", SalesLine."VAT Calculation Type");
        end else
            Clear(VATPostingSetup);
        SalesLine."Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        SalesLine."Prepayment VAT %" := VATPostingSetup."VAT %";
        SalesLine."Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
        SalesLine."Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
    end;

    [EventSubscriber(ObjectType::Codeunit, 84, 'OnAfterCreateSalesOrder', '', false, false)]
    local procedure Copyorder(var SalesHeader: Record "Sales Header"; var SkipMessage: Boolean)
    var
    begin
        Clear(SalesHeader."Last Prepayment No.");
        Clear(SalesHeader."Prepayment %");
        clear(SalesHeader."Prepmt. Payment Discount %");
        Clear(SalesHeader."Compress Prepayment");
        Clear(SalesHeader."Prepayment Due Date");
        SalesHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 87, 'OnRunOnBeforeResetQuantityFields', '', false, false)]
    local procedure CopyLineorder(var BlanketOrderSalesLine: Record "Sales Line"; var SalesOrderLine: Record "Sales Line")
    var
    begin
        clear(SalesOrderLine."Prepayment %");
        SalesOrderLine.Validate("Prepayment %");
        Clear(SalesOrderLine."Prepmt. Amt. Incl. VAT");
        Clear(SalesOrderLine."Prepmt. Amount Inv. Incl. VAT");
        Clear(SalesOrderLine."Prepmt. Amt. Inv.");
        clear(SalesOrderLine."Prepayment Amount");
        clear(SalesOrderLine."Prepmt. Line Amount");
        Clear(SalesOrderLine."Prepmt. VAT Base Amt.");
        Clear(SalesOrderLine."Prepmt Amt Deducted");
        Clear(SalesOrderLine."Prepmt. Amount Inv. (LCY)");
        Clear(SalesOrderLine."Prepmt. VAT Amount Inv. (LCY)");
        SalesOrderLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforeAdjustPrepmtAmountLCY', '', false, false)]
    local procedure ignoreprepay(SalesHeader: Record "Sales Header"; var PrepmtSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
    begin
        if SalesHeader."Prepayment %" = 0 then begin
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostCustOnAfterAssignReceivablesAccount', '', false, false)]
    local procedure Changetobank(GenJnlLine: Record "Gen. Journal Line"; CustomerPostingGroup: Record "Customer Posting Group"; var ReceivablesAccount: Code[20])
    var
        bank: Record "Bank Account Posting Group";
    begin
        if GenJnlLine."Prepmt. Bank" <> '' then begin
            bank.SetFilter(Code, '%1', GenJnlLine."Prepmt. Bank");
            if bank.FindSet() then begin
                ReceivablesAccount := bank."G/L Account No.";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterGLFinishPosting', '', false, false)]
    local procedure Changetobank2(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        bank: Record "Bank Account Posting Group";
    begin
        if GenJnlLine."Prepmt. Bank" <> '' then begin
            bank.SetFilter(Code, '%1', GenJnlLine."Prepmt. Bank");
            if bank.FindSet() then begin
                GLEntry."G/L Account No." := bank."G/L Account No.";
                GLEntry.Modify();
            end;
        end;
    end;

    var
        PreviewMode: Boolean;
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        GenJournalTemplate: Record "Gen. Journal Template";
        ErrorMessageMgt: Codeunit "Error Message Management";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SuppressCommit: Boolean;
        SpecifyInvNoSerieTok: Label 'Specify the code for the number series that will be used to assign numbers to posted sales prepayment invoices.';
        SpecifyCrNoSerieTok: Label 'Specify the code for the number series that will be used to assign numbers to posted sales prepayment credit memos.';
        Text002: Label 'Posting Prepayment Lines   #2######\';
        Text003: Label '%1 %2 -> Invoice %3';
        Text004: Label 'Posting sales and VAT      #3######\';
        Text005: Label 'Posting to customers       #4######\';
        Text006: Label 'Posting to bal. account    #5######';
        Text011: Label '%1 %2 -> Credit Memo %3';
        Text012: Label 'Prepayment %1, %2 %3.';
        Text018: Label 'must be positive when %1 is not 0';
        Text019: Label 'Invoice,Credit Memo';
        TempGlobalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer" temporary;
        GenPostingSetup: Record "General Posting Setup";
        TempSalesLine: Record "Sales Line" temporary;
        PostingDateNotAllowedErr: Label '%1 is not within your range of allowed posting dates.', Comment = '%1 - Posting Date field caption';
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        VATPostingSetup: Record "VAT Posting Setup";
        UpdateTok: Label '%1 %2', Locked = true;
}