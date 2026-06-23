codeunit 70103 FixedAssets
{
    Permissions = TableData "WHT Buss Posting Group" = rimd,
                  TableData "WHT Product Posting Group" = rimd,
                  TableData "Purchase Line" = rimd,
                  TableData "Purchase Header" = rimd,
                  TableData "Purch. Inv. Line" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "WHT Posting Setup" = rimd,
                  tabledata "Fixed Asset" = rimd,
                  tabledata "FA Ledger Entry" = rimd,
                  TableData "G/L Entry" = rimd;
    TableNo = "Fixed Asset";
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Make FA Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    procedure copyquantity(var FALedgerEntry: Record "FA Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Quantity FA" <> 0 then begin
            FALedgerEntry.Quantity := GenJournalLine."Quantity FA";
        end
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Check Line", 'OnCheckConsistencyOnBeforeCheckQuantity', '', false, false)]
    procedure skipcheck(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var FAJournalLine: Record "FA Journal Line")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPrepareLineOnAfterFillInvoicePostingBuffer', '', false, false)]
    procedure copyWHtLine(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; PurchLine: Record "Purchase Line"; var TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary; var FALineNo: Integer; var InvDefLineNo: Integer; var DeferralLineNo: Integer; var IsHandled: Boolean)
    begin
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
            InvoicePostingBuffer.Quantity := PurchLine.Quantity;
            InvoicePostingBuffer."QTY FA" := PurchLine.Quantity;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    procedure copyinvoicetogjline(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        if TempInvoicePostingBuffer."QTY FA" <> 0 then begin
            GenJnlLine."Quantity FA" := TempInvoicePostingBuffer."QTY FA";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Disposal", 'OnAfterSetEntryAmountsOnBeforeGainLoss', '', false, false)]
    procedure Disposalperqty(FANo: Code[20]; FADeprBook: Record "FA Depreciation Book"; DeprBookCode: Code[10]; var EntryAmounts: array[14] of Decimal; var GainLoss: Decimal; var IsHandled: Boolean)
    begin
        FADeprBook.CalcFields("Remaining Quantity", "Acquisition Cost All");
        EntryAmounts[3] := -1 * (FADeprBook."Acquisition Cost All" / FADeprBook."Remaining Quantity");
        IsHandled := true;
        GainLoss := (FADeprBook."Book Value" + FADeprBook."Proceeds on Disposal") / FADeprBook."Remaining Quantity";
        EntryAmounts[4] := ABS(GainLoss + EntryAmounts[3]);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Insert Ledger Entry", 'OnBeforeInsertFA', '', false, false)]
    procedure amountgainloss(var FALedgerEntry: Record "FA Ledger Entry")
    begin
        if FALedgerEntry.Quantity < 0 then begin
            FALedgerEntry.Amount := FALedgerEntry.Amount * Abs(FALedgerEntry.Quantity);
            FALedgerEntry."Amount (LCY)" := FALedgerEntry."Amount (LCY)" * Abs(FALedgerEntry.Quantity);
            FALedgerEntry."Disposal Qty." := FALedgerEntry.Quantity;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Insert Ledger Entry", 'OnInsertFAOnAfterInsertFALedgEntry', '', false, false)]
    procedure qtydisposal(var FALedgerEntry: Record "FA Ledger Entry"; FALedgerEntry3: Record "FA Ledger Entry")
    begin
        if FALedgerEntry."FA Posting Category" = FALedgerEntry."FA Posting Category"::Disposal then begin
            if FALedgerEntry."FA Posting Type" = FALedgerEntry."FA Posting Type"::"Acquisition Cost" then begin
                FALedgerEntry.Quantity := FALedgerEntry."Disposal Qty.";
                FALedgerEntry."Part of Book Value" := true;
                FALedgerEntry.Modify();
            end;

            if FALedgerEntry."FA Posting Type" = FALedgerEntry."FA Posting Type"::"Depreciation" then begin
                FALedgerEntry.Quantity := 0;
                FALedgerEntry."Part of Book Value" := true;
                FALedgerEntry.Modify();
            end;
        end;

        if FALedgerEntry."FA Posting Type" = FALedgerEntry."FA Posting Type"::"Proceeds on Disposal" then begin
            FALedgerEntry.Quantity := 0;
            FALedgerEntry.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Disposal", 'OnGetDisposalTypeSetOnAfterSetFilterFALedgEntry', '', false, false)]
    procedure setdisposalfirst(var FALedgerEntry: Record "FA Ledger Entry")
    begin
        FALedgerEntry.SetFilter(Amount, '<%1', 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Normal Depreciation", 'OnBeforeSkipRecord', '', false, false)]
    procedure manualdepre(FixedAsset: Record "Fixed Asset";
    DeprBook: Record "Depreciation Book";
    DisposalDate: date;
    AcquisitionDate: date;
    UntilDate: Date;
    FADeprMethod: Enum "FA Depreciation Method";
                      BookValue: Decimal;
                      DeprBasis: Decimal;
                      SalvageValue: Decimal;
                      MinusBookValue: Decimal;
    var ReturnValue: Boolean;
    var IsHandled: Boolean)
    begin
        if BookValue > 0 then begin
            ReturnValue := false;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforePostFixedAsset', '', false, false)]
    procedure cleardisposal(FANo: Code[20]; DeprBookCode: Code[10]; FAPostingType: Enum "FA Journal Line FA Posting Type"; FALedgEntry: Record "FA Ledger Entry"; var IsHandled: Boolean)
    var
        fadprebook: Record "FA Depreciation Book";
    begin
        if FAPostingType <> FAPostingType::Depreciation then begin
            exit;
        end;

        fadprebook.SetFilter("FA No.", '%1', FANo);
        if fadprebook.FindFirst() then begin
            Clear(fadprebook."Disposal Date");
            fadprebook.Modify();
        end;
    end;
}