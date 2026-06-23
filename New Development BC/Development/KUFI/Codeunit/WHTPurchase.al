codeunit 70100 WHTPurchase
{
    Permissions = TableData "WHT Buss Posting Group" = rimd,
                  TableData "WHT Product Posting Group" = rimd,
                  TableData "Purchase Line" = rimd,
                  TableData "Purchase Header" = rimd,
                  TableData "Purch. Inv. Line" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "WHT Posting Setup" = rimd,
                  TableData "G/L Entry" = rimd;
    TableNo = "WHT Entries";
    trigger OnRun()
    begin

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
    // procedure FillDocumentEntry(var DocumentEntry: Record "Document Entry")
    // begin
    //     if TempWHT.FindSet() then
    //         repeat
    //             PostingPreview.InsertDocumentEntry(TempWHT, DocumentEntry);
    //         until TempWHT.Next() = 0;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
    // procedure ShowEntries(TableNo: Integer)
    // begin
    //     if tableNo = Database::"WHT Entries" then
    //         Page.run(page::"WHT Entries Preview", TempWHT)
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPrepareLineOnAfterFillInvoicePostingBuffer', '', false, false)]
    procedure copyWHtLine(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; PurchLine: Record "Purchase Line"; var TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var FALineNo: Integer; var InvDefLineNo: Integer; var DeferralLineNo: Integer; var IsHandled: Boolean)
    begin
        if PurchLine."WHT %" <> 0 then begin
            InvoicePostingBuffer."WHT %" := PurchLine."WHT %";
            InvoicePostingBuffer."WHT Bus. Posting Group" := PurchLine."WHT Business Posting Group";
            InvoicePostingBuffer."WHT Prod. Posting Group" := PurchLine."WHT Product Posting Group";
            //InvoicePostingBuffer."WHT Amount" := Round((InvoicePostingBuffer."VAT Base Amount" * InvoicePostingBuffer."WHT %") / 100)
            InvoicePostingBuffer."WHT Amount" := PurchLine."WHT Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    procedure copyinvoicetogjline(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        if TempInvoicePostingBuffer."WHT %" <> 0 then begin
            GenJnlLine."WHT %" := TempInvoicePostingBuffer."WHT %";
            GenJnlLine."WHT Business Posting Group" := TempInvoicePostingBuffer."WHT Bus. Posting Group";
            GenJnlLine."WHT Product Posting Group" := TempInvoicePostingBuffer."WHT Prod. Posting Group";
            GenJnlLine."WHT Amount" := TempInvoicePostingBuffer."WHT Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    procedure TotalWithWHT(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        if TotalPurchLine."WHT Amount" <> 0 then begin
            GenJnlLine.Amount := -(TotalPurchLine."Amount Including VAT" - TotalPurchLine."WHT Amount");
            GenJnlLine."WHT Amount" := TotalPurchLine."WHT Amount";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    procedure SkipCheckWHT(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line"; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal; var NextEntryNo: Integer; var TotalAmount: Decimal; var TotalAddCurrAmount: Decimal; var GLEntry: Record "G/L Entry")
    begin
        if GenJournalLine."WHT Amount" <> 0 then begin
            BalanceCheckAmount := 0;
            BalanceCheckAmount2 := 0;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    procedure copyitemtopl(var PurchLine: Record "Purchase Line"; Item: Record Item; CurrentFieldNo: Integer; PurchHeader: Record "Purchase Header")
    begin
        PurchLine."WHT Product Posting Group" := item."WHT Product Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    procedure copyphtopl(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; var TempPurchLine: record "Purchase Line" temporary)
    begin
        PurchLine."WHT Business Posting Group" := PurchHeader."WHT Business Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    procedure copyvendtoph(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."WHT Business Posting Group" := Vendor."WHT Business Posting Group"
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateNoPurchaseLine', '', false, false)]
    procedure calculatewht(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header")
    var
        whtsetup: Record "WHT Posting Setup";
    begin
        whtsetup.SetFilter("WHT Business Posting Group", '%1', PurchaseLine."WHT Business Posting Group");
        whtsetup.SetFilter("WHT Product Posting Group", '%1', PurchaseLine."WHT Product Posting Group");
        if whtsetup.FindFirst() then begin
            PurchaseLine."WHT %" := whtsetup."WHT %";
            PurchaseLine."WHT Amount" := Round((PurchaseLine."Line Amount" * whtsetup."WHT %") / 100);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', false, false)]
    procedure PostWHTPurchase(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup"; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary)
    var
        GJPost: Codeunit "Gen. Jnl.-Post Line";
        whtsetup: Record "WHT Posting Setup";
    begin
        if GenJnlLine."WHT Amount" <> 0 then begin
            if GenJnlLine."Source Code" <> 'PURCHASES' then begin
                exit
            end;
            //TempWHT.DeleteAll();
            WHTEntry.Init();
            WHTEntry.CopyFromGenJnlLine(GenJnlLine);
            WHTEntry.Insert(true);
            whtsetup.SetFilter("WHT Business Posting Group", '%1', GenJnlLine."WHT Business Posting Group");
            whtsetup.SetFilter("WHT Product Posting Group", '%1', GenJnlLine."WHT Product Posting Group");
            if whtsetup.FindFirst() then begin
                LastEntryNo := NextEntryNo;
                GJPost.InitGLEntry(GenJnlLine, GLEntry, whtsetup."Payable WHT Account Code", GenJnlLine."WHT Amount", GenJnlLine."WHT Amount", true, true, GenJnlLine."WHT Amount");
                GLEntry."Entry No." := LastEntryNo;
                GLEntry.Amount := -GLEntry.Amount;
                GLEntry."Source Currency Amount" := -GLEntry."Source Currency Amount";
                //GJPost.InsertGLEntry(GenJnlLine, GLEntry, true);
                TempGLEntryBuf := GLEntry;
                TempGLEntryBuf.Insert();
                NextEntryNo := NextEntryNo + 1;
            end;
        end;
        // if WHTEntry.Amount <> 0 then begin
        //     if COPYSTR(WHTEntry."Document No.", 1, 2) = '**' then begin
        //         WHTTemporary(WHTEntry);
        //     end;
        // end
    end;

    // procedure WHTTemporary(WHTEntries: Record "WHT Entries")
    // begin
    //     TempWHT := WHTEntries;
    //     TempWHT.Insert();
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure WHTtoPIL(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean)
    begin
        PurchInvLine."WHT %" := PurchLine."WHT %";
        PurchInvLine."WHT Business Posting Group" := PurchLine."WHT Business Posting Group";
        PurchInvLine."WHT Product Posting Group" := PurchLine."WHT Product Posting Group";
        PurchInvLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure WHTtoPIH(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        PurchInvHeader."WHT Business Posting Group" := PurchHeader."WHT Business Posting Group";
        PurchInvHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterIncrAmount', '', false, false)]
    local procedure TotalWHT(var TotalPurchLine: Record "Purchase Line"; PurchLine: Record "Purchase Line")
    begin
        TotalPurchLine."WHT Amount" += PurchLine."WHT Amount";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetGLAccount', '', false, false)]
    local procedure UpdateWHTGJ(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account"; CallingFieldNo: Integer)
    begin
        GenJournalLine."WHT Business Posting Group" := GLAccount."WHT Bus. Posting Group";
        GenJournalLine."WHT Product Posting Group" := GLAccount."WHT Prod. Posting Group";
        if GLAccount."WHT Prod. Posting Group" <> '' then begin
            WHTAmount(GenJournalLine);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateAmount', '', false, false)]
    local procedure UpdateWHTAmount(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine."WHT Product Posting Group" <> '' then begin
            WHTAmount(GenJnlLine);
        end;
    end;

    Local Procedure WHTAmount(var GenJou: Record "Gen. Journal Line")
    var
        whtsetup: Record "WHT Posting Setup";
    begin
        whtsetup.SetFilter("WHT Business Posting Group", '%1', GenJou."WHT Business Posting Group");
        whtsetup.SetFilter("WHT Product Posting Group", '%1', GenJou."WHT Product Posting Group");
        if whtsetup.FindFirst() then begin
            GenJou."WHT %" := whtsetup."WHT %";
            if GenJou."VAT Base Amount" <> 0 then begin
                GenJou."WHT Amount" := Round((GenJou."VAT Base Amount" * whtsetup."WHT %") / 100);
            end else if GenJou.Amount <> 0 then begin
                GenJou."WHT Amount" := Round((GenJou.Amount * whtsetup."WHT %") / 100);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', false, false)]
    procedure PostWHTGJ(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup"; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary)
    var
        GJPost: Codeunit "Gen. Jnl.-Post Line";
        whtsetup: Record "WHT Posting Setup";
    begin
        if GenJnlLine."WHT Amount" <> 0 then begin
            if GenJnlLine."Source Code" <> 'GENJNL' then begin
                exit
            end;
            WHTEntry.Init();
            WHTEntry.CopyFromGenJnlLine(GenJnlLine);
            WHTEntry.Insert(true);
            whtsetup.SetFilter("WHT Business Posting Group", '%1', GenJnlLine."WHT Business Posting Group");
            whtsetup.SetFilter("WHT Product Posting Group", '%1', GenJnlLine."WHT Product Posting Group");
            if whtsetup.FindFirst() then begin
                LastEntryNo := NextEntryNo;
                if GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Purchase then begin
                    GJPost.InitGLEntry(GenJnlLine, GLEntry, whtsetup."Payable WHT Account Code", GenJnlLine."WHT Amount", GenJnlLine."WHT Amount", true, true, GenJnlLine."WHT Amount");
                end else if GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Sale then begin
                    GJPost.InitGLEntry(GenJnlLine, GLEntry, whtsetup."Receivable WHT Account Code", GenJnlLine."WHT Amount", GenJnlLine."WHT Amount", true, true, GenJnlLine."WHT Amount");
                end;
                GLEntry."Entry No." := LastEntryNo;
                GLEntry.Amount := -GLEntry.Amount;
                TempGLEntryBuf := GLEntry;
                TempGLEntryBuf.Insert();
                NextEntryNo := NextEntryNo + 1;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Exchange Acc. G/L Journal Line", 'OnAfterOnRun', '', false, false)]
    procedure ClearWHTOnBalance(var GenJournalLine: Record "Gen. Journal Line"; GenJournalLine2: Record "Gen. Journal Line")
    begin
        if GenJournalLine."WHT Amount" <> 0 then begin
            if GenJournalLine."Source Code" <> 'GENJNL' then begin
                exit
            end;
            GenJournalLine.Amount := GenJournalLine.Amount + GenJournalLine."WHT Amount";
            GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
            GenJournalLine."WHT %" := 0;
            GenJournalLine."WHT Amount" := 0;
        end;
    end;

    var
        TempWHT: Record "WHT Entries" temporary;
        WHTEntry: Record "WHT Entries";
        LastEntryNo: Integer;

}