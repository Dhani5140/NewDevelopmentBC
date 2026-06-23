codeunit 70005 AppliedLedger
{
    Permissions = TableData "Sales Header" = rimd,
                  TableData "Sales Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "General Posting Setup" = rimd,
                  tabledata "G/L Entry" = rimd;
    TableNo = "Cust. Ledger Entry";
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 21, 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure copytocl(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        CustLedgerEntry."Blanket No." := GenJournalLine."Blanket No.";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure copytognj(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetFilter("Document No.", '%1', SalesHeader."No.");
        SalesLine.SetFilter("Blanket Order No.", '<>%1', '');
        if SalesLine.FindSet() then begin
            GenJournalLine."Blanket No." := SalesLine."Blanket Order No.";
        end;
    end;

    procedure PostDirectApplication(Custled: Record "Cust. Ledger Entry"; PreviewMode: Boolean)
    var
        RecBeforeRunPostApplicationCustLedgerEntry: Record "Cust. Ledger Entry";
        ApplyUnapplyParameters: Record "Apply Unapply Parameters";
        NewApplyUnapplyParameters: Record "Apply Unapply Parameters";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        PostApplication: Page "Post Application";
        Applied: Boolean;
        ApplicationDate: Date;
        IsHandled: Boolean;
        TempCustLed: Record "Cust. Ledger Entry" temporary;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        TempCustLed.TransferFields(Custled);

        TempCustLed."Amount to Apply" := TempCustLed."Remaining Amount";
        TempCustLed."Applying Entry" := true;
        TempCustLed."Applies-to ID" := UserId;


        ApplicationDate := TempCustLed."Posting Date";
        Clear(ApplyUnapplyParameters);
        ApplyUnapplyParameters.CopyFromCustLedgEntry(TempCustLed);
        GLSetup.GetRecordOnce();
        ApplyUnapplyParameters."Posting Date" := ApplicationDate;
        if GLSetup."Journal Templ. Name Mandatory" then begin
            GLSetup.TestField("Apply Jnl. Template Name");
            GLSetup.TestField("Apply Jnl. Batch Name");
            ApplyUnapplyParameters."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
            ApplyUnapplyParameters."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
        end;
        PostApplication.SetParameters(ApplyUnapplyParameters);
        RecBeforeRunPostApplicationCustLedgerEntry := TempCustLed;
        if ACTION::OK = PostApplication.RunModal() then begin
            if TempCustLed."Entry No." <> RecBeforeRunPostApplicationCustLedgerEntry."Entry No." then
                TempCustLed := RecBeforeRunPostApplicationCustLedgerEntry;
            PostApplication.GetParameters(NewApplyUnapplyParameters);
            if NewApplyUnapplyParameters."Posting Date" < ApplicationDate then
                Error(ApplicationDateErr, Custled.FieldCaption("Posting Date"), Custled.TableCaption());
        end else
            exit;


        if PreviewMode then
            CustEntryApplyPostedEntries.PreviewApply(TempCustLed, NewApplyUnapplyParameters)
        else
            Applied := CustEntryApplyPostedEntries.Apply(TempCustLed, NewApplyUnapplyParameters);


        if (not PreviewMode) and Applied then begin
            // Message(ApplicationPostedMsg);
            // PostingDone := true;
            // CurrPage.Close();
        end;
    end;

    procedure AppliesEntries(CustLed: Record "Cust. Ledger Entry")
    var
        ApplyEntry: Record "Cust. Ledger Entry";
        CustApply: Codeunit "Cust. Entry-SetAppl.ID";
        AmountTotal: Decimal;
        AmountApply: Decimal;
    begin
        Custled.CalcFields("Remaining Amount");
        AmountTotal := -1 * Custled."Remaining Amount";

        ApplyEntry.SetFilter("Document Type", '%1', ApplyEntry."Document Type"::Payment);
        ApplyEntry.SetFilter("Blanket No.", Custled."Blanket No.");
        ApplyEntry.SetRange(Open, True);
        ApplyEntry.SetRange("Applies-to ID", '');
        if ApplyEntry.Find('-') then begin
            repeat
                if AmountTotal >= 0 then begin
                    break;
                end;
                CustEntryApplID := UserId;
                UpdateCustLedgerEntry(CustLed, ApplyEntry, UserId);
                AmountTotal := AmountTotal + ApplyEntry."Amount to Apply";
            until ApplyEntry.Next() = 0;
        end;
    end;

    local procedure UpdateCustLedgerEntry(var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary; ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; AppliesToID: Code[50])
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        CustLedgerEntry.Copy(TempCustLedgerEntry);
        CustLedgerEntry.TestField(Open, true);
        CustLedgerEntry."Applies-to ID" := CustEntryApplID;
        if CustLedgerEntry."Applies-to ID" = '' then begin
            CustLedgerEntry."Accepted Pmt. Disc. Tolerance" := false;
            CustLedgerEntry."Accepted Payment Tolerance" := 0;
        end;
        if ((CustLedgerEntry."Amount to Apply" <> 0) and (CustEntryApplID = '')) or
           (CustEntryApplID = '')
        then
            CustLedgerEntry."Amount to Apply" := 0
        else
            if CustLedgerEntry."Amount to Apply" = 0 then begin
                CustLedgerEntry.CalcFields("Remaining Amount");
                CustLedgerEntry."Amount to Apply" := CustLedgerEntry."Remaining Amount"
            end;

        if CustLedgerEntry."Entry No." = ApplyingCustLedgerEntry."Entry No." then
            CustLedgerEntry."Applying Entry" := ApplyingCustLedgerEntry."Applying Entry";
        CustLedgerEntry.Modify();
    end;

    procedure CalcApplnAmount(CustLedgEntry: Record "Cust. Ledger Entry"; TempApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    begin

        if TempApplyingCustLedgEntry."Entry No." <> 0 then begin
            CustLedgEntry.CalcFields("Remaining Amount");
            AppliedCustLedgEntry.SetFilter("Entry No.", '<>%1', TempApplyingCustLedgEntry."Entry No.");
        end;

        // HandleChosenEntries(
        //     CalcType::Direct, CustLedgEntry."Remaining Amount", CustLedgEntry."Currency Code", CustLedgEntry."Posting Date");
    end;

    // procedure HandleChosenEntries(Type: Enum "Customer Apply Calculation Type"; CurrentAmount: Decimal; CurrencyCode: Code[10]; PostingDate: Date)
    // var
    //     TempAppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
    //     PossiblePmtDisc: Decimal;
    //     OldPmtDisc: Decimal;
    //     CorrectionAmount: Decimal;
    //     RemainingAmountExclDiscounts: Decimal;
    //     CanUseDisc: Boolean;
    //     FromZeroGenJnl: Boolean;
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     if IsHandled then
    //         exit;

    //     if not AppliedCustLedgEntry.FindSet(false) then
    //         exit;

    //     repeat
    //         TempAppliedCustLedgEntry := AppliedCustLedgEntry;
    //         TempAppliedCustLedgEntry.Insert();
    //     until AppliedCustLedgEntry.Next() = 0;

    //     FromZeroGenJnl := (CurrentAmount = 0) and (Type = Type::"Gen. Jnl. Line");

    //     repeat
    //         if not FromZeroGenJnl then
    //             TempAppliedCustLedgEntry.SetRange(Positive, CurrentAmount < 0);
    //         if TempAppliedCustLedgEntry.FindFirst() then begin
    //             ExchangeLedgerEntryAmounts(Type, CurrencyCode, TempAppliedCustLedgEntry, PostingDate);

    //             CanUseDisc := PaymentToleranceMgt.CheckCalcPmtDiscCust(CustLedgEntry, TempAppliedCustLedgEntry, 0, false, false);

    //             if CanUseDisc and
    //                (Abs(TempAppliedCustLedgEntry."Amount to Apply") >=
    //                 Abs(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate)))
    //             then
    //                 if Abs(CurrentAmount) >
    //                    Abs(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate))
    //                 then begin
    //                     PmtDiscAmount += TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                     CurrentAmount += TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                 end else
    //                     if Abs(CurrentAmount) =
    //                        Abs(TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate))
    //                     then begin
    //                         PmtDiscAmount += TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                         CurrentAmount +=
    //                           TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                         AppliedAmount += CorrectionAmount;
    //                     end else
    //                         if FromZeroGenJnl then begin
    //                             PmtDiscAmount += TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                             CurrentAmount +=
    //                               TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                         end else begin
    //                             PossiblePmtDisc := TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                             RemainingAmountExclDiscounts :=
    //                               TempAppliedCustLedgEntry."Remaining Amount" - PossiblePmtDisc - TempAppliedCustLedgEntry."Max. Payment Tolerance";
    //                             if Abs(CurrentAmount) + Abs(CalcOppositeEntriesAmount(TempAppliedCustLedgEntry)) >=
    //                                Abs(RemainingAmountExclDiscounts)
    //                             then begin
    //                                 PmtDiscAmount += PossiblePmtDisc;
    //                                 AppliedAmount += CorrectionAmount;
    //                             end;
    //                             CurrentAmount +=
    //                               TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry.GetRemainingPmtDiscPossible(PostingDate);
    //                         end
    //             else begin
    //                 if ((CurrentAmount + TempAppliedCustLedgEntry."Amount to Apply") * CurrentAmount) <= 0 then
    //                     AppliedAmount += CorrectionAmount;
    //                 CurrentAmount += TempAppliedCustLedgEntry."Amount to Apply";
    //             end;
    //         end else begin
    //             TempAppliedCustLedgEntry.SetRange(Positive);
    //             TempAppliedCustLedgEntry.FindFirst();
    //             ExchangeLedgerEntryAmounts(Type, CurrencyCode, TempAppliedCustLedgEntry, PostingDate);
    //         end;

    //         if OldPmtDisc <> PmtDiscAmount then
    //             AppliedAmount += TempAppliedCustLedgEntry."Remaining Amount"
    //         else
    //             AppliedAmount += TempAppliedCustLedgEntry."Amount to Apply";
    //         OldPmtDisc := PmtDiscAmount;

    //         if PossiblePmtDisc <> 0 then
    //             CorrectionAmount := TempAppliedCustLedgEntry."Remaining Amount" - TempAppliedCustLedgEntry."Amount to Apply"
    //         else
    //             CorrectionAmount := 0;

    //         if not DifferentCurrenciesInAppln then
    //             DifferentCurrenciesInAppln := ApplnCurrencyCode <> TempAppliedCustLedgEntry."Currency Code";

    //         TempAppliedCustLedgEntry.SetRange(Positive);

    //     until not TempAppliedCustLedgEntry.FindFirst();
    // end;

    procedure ExchangeLedgerEntryAmounts(Type: Enum "Customer Apply Calculation Type"; CurrencyCode: Code[10]; var CalcCustLedgEntry: Record "Cust. Ledger Entry"; PostingDate: Date)
    var
        CalculateCurrency, IsHandled : Boolean;
    begin
        CalcCustLedgEntry.CalcFields("Remaining Amount");

        if Type = Type::Direct then
            CalculateCurrency := TempApplyingCustLedgEntry."Entry No." <> 0
        else
            CalculateCurrency := true;

        IsHandled := false;
        exit;

        if (CurrencyCode <> CalcCustLedgEntry."Currency Code") and CalculateCurrency then begin
            CalcCustLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Remaining Amount", CalcCustLedgEntry."Currency Code", CurrencyCode, PostingDate);
            CalcCustLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Remaining Pmt. Disc. Possible", CalcCustLedgEntry."Currency Code", CurrencyCode, PostingDate);
            CalcCustLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                CalcCustLedgEntry."Amount to Apply", CalcCustLedgEntry."Currency Code", CurrencyCode, PostingDate);
        end;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ApplicationDateErr: Label 'The %1 entered must not be before the %1 on the %2.';

        AppliedCustomer: Page "Apply Customer Entries";
        AppliedCustLedgEntry: Record "Cust. Ledger Entry";
        CalcType: Enum "Customer Apply Calculation Type";
        TempApplyingCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        CustEntryApplID: Code[50];
}