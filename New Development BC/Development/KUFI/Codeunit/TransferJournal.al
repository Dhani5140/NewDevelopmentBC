codeunit 50103 TransferJournal
{
    Permissions = TableData 81 = rimd,
                  TableData 330 = rimd,
                  TableData 472 = rimd,
                  TableData 17 = rimd;
    //TableNo = 81;
    trigger OnRun()
    begin
        CopyToGenjournal();
        CheckBalance()
    end;

    procedure CopytoOtherCompany(GenLed: Record 17)
    var
        SourceGLE: Record 17;
        GLE: Record 17;
        Companies: Record Company;
        CopyToCompany: Text[30];
        CurrExchRate: Record 330;
        NewAmount: Decimal;
    begin
        if Page.RunModal(Page::Companies, Companies) <> Action::LookupOK then
            exit;

        CopyToCompany := Companies.Name;

        if not GLE.ChangeCompany(CopyToCompany) then
            Error('Cannot change to company %1', CopyToCompany);

        SourceGLE.SetRange("Document No.", GenLed."Document No.");

        if SourceGLE.FindSet() then begin
            repeat
                CurrExchRate.Reset();
                CurrExchRate.SetRange("Currency Code", 'USD');
                CurrExchRate.SetFilter(
                    "Starting Date",
                    '<=%1',
                    SourceGLE."Posting Date");

                if not CurrExchRate.FindLast() then
                    Error(
                        'USD exchange rate not found for %1',
                        SourceGLE."Posting Date");

                NewAmount :=
                    Round(
                        SourceGLE.Amount /
                        CurrExchRate."Relational Exch. Rate Amount",
                        0.01);

                GLE.Init();
                GLE.TransferFields(SourceGLE);

                GLE.Amount := NewAmount;

                if SourceGLE."Debit Amount" <> 0 then begin
                    GLE."Debit Amount" := Abs(NewAmount);
                    GLE."Credit Amount" := 0;
                end else begin
                    GLE."Credit Amount" := Abs(NewAmount);
                    GLE."Debit Amount" := 0;
                end;

                GLE.Insert();
            until SourceGLE.Next() = 0;
        end;

        Message('Transfer data to company %1 success', CopyToCompany);
    end;

    procedure copyTemporaryGLE(GenLed: Record 17)
    var
        SourceGLE: Record 17;
        Companies: Record Company;
        CopyToCompany: Text[30];
        TemporaryTransfer: Record 50104;
    begin
        Clear(CopyToCompany);
        CopyToCompany := 'Cronus 2';
        if not TemporaryTransfer.ChangeCompany(CopyToCompany) then
            Error('Cannot change to company %1', CopyToCompany);
        SourceGLE.SetRange("Document No.", GenLed."Document No.");

        if SourceGLE.FindSet() then begin
            repeat
                TemporaryTransfer.Init();
                TemporaryTransfer."Document No." := SourceGLE."Document No.";
                TemporaryTransfer.Date := SourceGLE."Posting Date";
                TemporaryTransfer."Account No." := SourceGLE."G/L Account No.";
                TemporaryTransfer."Account Type" := TemporaryTransfer."Account Type"::"G/L Account";
                TemporaryTransfer.Description := SourceGLE.Description;
                TemporaryTransfer.Comment := SourceGLE.Comment;
                TemporaryTransfer.Amount := SourceGLE.Amount;
                TemporaryTransfer."Debit Amount" := SourceGLE."Debit Amount";
                TemporaryTransfer."Credit Amount" := SourceGLE."Credit Amount";
                // TemporaryTransfer."Line No." := LineNo;
                TemporaryTransfer."Line No." := SourceGLE."Entry No.";
                TemporaryTransfer.Insert();
            until SourceGLE.Next() = 0;
        end;

        Message('Transfer data to company %1 success', CopyToCompany);
    end;


    procedure CopyToGenjournal()
    var
        genjou: Record "Gen. Journal Line";
        Temporary: Record TemporaryTransfer;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        Temporary.SetFilter(Amount, '<>%1', 0);
        if Temporary.FindSet() then begin
            repeat
                Temporary.CalcFields(Type);
                CurrExchRate.Reset();
                CurrExchRate.SetRange("Currency Code", 'USD');
                CurrExchRate.SetFilter(
                    "Starting Date",
                    '<=%1',
                    Temporary.Date);
                if not CurrExchRate.FindLast() then
                    Error(
                        'USD exchange rate not found for %1',
                        Temporary.Date);
                genjou.Init();
                genjou."Journal Template Name" := 'GENERAL';
                genjou."Journal Batch Name" := 'DEFAULT';
                genjou."Document No." := Temporary."Document No.";
                genjou."Account Type" := Temporary."Account Type";
                genjou."Account No." := Temporary."Account No.";
                genjou."Posting Date" := Temporary.Date;
                genjou."Document Date" := Temporary.Date;
                genjou."Line No." := Temporary."Line No.";
                genjou.Insert();
                if Temporary.Type = Temporary.Type::"Balance Sheet" then begin
                    genjou.Amount := Temporary.Amount / CurrExchRate."Exchange Rate Amount BS";
                end else begin
                    genjou.Amount := Temporary.Amount / CurrExchRate."Exchange Rate Amount PL";
                end;
                genjou.Validate(Amount);
                genjou.Modify();
                Temporary.Transfer := true;
                Temporary.Modify();
            until Temporary.Next() = 0
        end;
    end;

    procedure CheckBalance()
    var
        sourcegenjou: Record "Gen. Journal Line";
        genjou: Record "Gen. Journal Line";
    begin
        sourcegenjou.SetFilter("Journal Template Name", 'GENERAL');
        sourcegenjou.SetFilter("Journal Batch Name", 'DEFAULT');
        if sourcegenjou.FindSet() then begin
            repeat
                if sourcegenjou.GetDocumentBalance(sourcegenjou) <> 0 then begin
                    genjou.Init();
                    genjou."Journal Template Name" := 'GENERAL';
                    genjou."Journal Batch Name" := 'DEFAULT';
                    genjou."Document No." := sourcegenjou."Document No.";
                    genjou.Amount := sourcegenjou.GetDocumentBalance(sourcegenjou);
                    genjou."Account Type" := genjou."Account Type"::"G/L Account";
                    genjou."Account No." := '8840';
                    genjou."Posting Date" := sourcegenjou."Posting Date";
                    genjou."Document Date" := sourcegenjou."Document Date";
                    genjou."Line No." := sourcegenjou."Line No.";
                end;
            until sourcegenjou.Next() = 0;
        end;
    end;

    procedure deleteGLE(GLE: Record 17)
    begin
        GLE.Delete();
    end;
}