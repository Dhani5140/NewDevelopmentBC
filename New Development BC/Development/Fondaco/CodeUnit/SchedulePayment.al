codeunit 70002 MIICUSchedule
{
    Permissions = TableData "MiiTabScheduleLine" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Cr.Memo Header" = rimd,
                  TableData "Sales Cr.Memo Line" = rimd,
                  TableData "General Posting Setup" = rimd,
                  tabledata "Cust. Ledger Entry" = rimd,
                  tabledata "Detailed Cust. Ledg. Entry" = rimd,
                  tabledata "G/L Entry" = rimd;
    TableNo = MiiTabScheduleHeader;
    trigger OnRun()
    begin

    end;

    procedure InsertScheduleHeader(SH: Record "Sales Header")
    var
        Header: Record MiiTabScheduleHeader;
    begin
        SH.CalcFields(Amount, "Amount Including VAT");
        Header.Init();
        Header."Start Date" := SH."Starting Date";
        //Header."No. of Periods" := SH.Termin.AsInteger();
        Header."Amount to Installment" := SH."Amount Including VAT";
        Header."Initial Amount Installment" := SH."Amount Including VAT";
        Header."Document No." := SH."No.";
        Header."Currency Code" := SH."Currency Code";
        Header.Insert();
    end;

    procedure InsertScheduleLine(Header: Record MiiTabScheduleHeader)
    var
        Line: Record MiiTabScheduleLine;
        AccountingPeriod: Record "Accounting Period";
        PeriodicCount: Integer;
        PostDate: Date;
        RunningDeferralTotal: Decimal;
        FirstPeriodDate: Date;
        SecondPeriodDate: Date;
        AmountToDefer: Decimal;
        AmountToDeferFirstPeriod: Decimal;
        HowManyDaysLeftInPeriod: Integer;
        NumberOfDaysInPeriod: Integer;
        FractionOfPeriod: Decimal;
        PeriodicDeferralAmount: Decimal;
    begin

        InitCurrency(Header."Currency Code");

        PeriodicDeferralAmount := Round(Header."Amount to Installment" / Header."No. of Periods", AmountRoundingPrecision);

        for PeriodicCount := 1 to (Header."No. of Periods") do begin
            InitializeDeferralHeaderAndSetPostDate(Line, Header, PeriodicCount, PostDate);

            AmountToDefer := Header."Amount to Installment";
            if PeriodicCount = 1 then
                Clear(RunningDeferralTotal);

            if PeriodicCount <> Header."No. of Periods" then begin
                AmountToDefer := Round(AmountToDefer / Header."No. of Periods", AmountRoundingPrecision);
                RunningDeferralTotal := RunningDeferralTotal + AmountToDefer;
            end else
                AmountToDefer := (Header."Amount to Installment" - RunningDeferralTotal);


            Line."Posting Date" := PostDate;
            Line.Description := CreateRecurringDescription(PostDate, 'Installment');
            Line.Amount := AmountToDefer;
            Line."Document No." := Header."Document No.";
            Line."Currency Code" := Header."Currency Code";
            Line.Insert();
        end;
    end;

    procedure InitializeDeferralHeaderAndSetPostDate(var Line: Record MiiTabScheduleLine; Header: Record MiiTabScheduleHeader; PeriodicCount: Integer; var PostDate: Date)
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        Line.Init();
        Line."Document No." := Line."Document No.";
        Line."Currency Code" := Line."Currency Code";

        if PeriodicCount = 1 then begin
            if not AccountingPeriod.IsEmpty() then begin
                AccountingPeriod.SetFilter("Starting Date", '..%1', Header."Start Date");
                if not AccountingPeriod.FindFirst() then
                    Error(DeferSchedOutOfBoundsErr);
            end;
            PostDate := Header."Start Date";
        end else begin
            if IsAccountingPeriodExist(AccountingPeriod, CalcDate('<CM>', PostDate) + 1) then begin
                AccountingPeriod.SetFilter("Starting Date", '>%1', PostDate);
                if not AccountingPeriod.FindFirst() then
                    Error(DeferSchedOutOfBoundsErr);
            end;
            PostDate := AccountingPeriod."Starting Date";
        end;
    end;

    local procedure IsAccountingPeriodExist(var AccountingPeriod: Record "Accounting Period"; PostingDate: Date): Boolean
    var
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
    begin
        AccountingPeriod.Reset();
        if not AccountingPeriod.IsEmpty() then
            exit(true);

        AccountingPeriodMgt.InitDefaultAccountingPeriod(AccountingPeriod, PostingDate);
        exit(false);
    end;

    procedure CreateRecurringDescription(PostingDate: Date; Description: Text[100]) FinalDescription: Text[100]
    var
        AccountingPeriod: Record "Accounting Period";
        Day: Integer;
        Week: Integer;
        Month: Integer;
        Year: Integer;
        MonthText: Text[30];
    begin
        Day := Date2DMY(PostingDate, 1);
        Week := Date2DWY(PostingDate, 2);
        Month := Date2DMY(PostingDate, 2);
        MonthText := Format(PostingDate, 0, '<Month Text>');
        Year := Date2DMY(PostingDate, 3);
        if IsAccountingPeriodExist(AccountingPeriod, PostingDate) then begin
            AccountingPeriod.SetRange("Starting Date", 0D, PostingDate);
            if not AccountingPeriod.FindLast() then
                AccountingPeriod.Name := '';
        end;
        FinalDescription :=
          CopyStr(StrSubstNo(Description, Day, Week, Month, MonthText, AccountingPeriod.Name, Year), 1, MaxStrLen(Description));
    end;

    local procedure UpdateDeferralLineDescription(var DeferralLine: Record "Deferral Line"; DeferralHeader: Record "Deferral Header"; DeferralTemplate: Record "Deferral Template"; PostDate: Date)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        exit;

        DeferralLine.Description := CreateRecurringDescription(PostDate, DeferralTemplate."Period Description");
    end;

    local procedure GetPeriodStartingDate(PostingDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if AccountingPeriod.IsEmpty() then
            exit(CalcDate('<-CM>', PostingDate));

        AccountingPeriod.SetFilter("Starting Date", '<%1', PostingDate);
        if AccountingPeriod.FindLast() then
            exit(AccountingPeriod."Starting Date");

        Error(DeferSchedOutOfBoundsErr);
    end;

    local procedure GetNextPeriodStartingDate(PostingDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        if AccountingPeriod.IsEmpty() then
            exit(CalcDate('<CM+1D>', PostingDate));

        AccountingPeriod.SetFilter("Starting Date", '>%1', PostingDate);
        if AccountingPeriod.FindFirst() then
            exit(AccountingPeriod."Starting Date");

        Error(DeferSchedOutOfBoundsErr);
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    var
        Currency: Record Currency;
    begin
        if CurrencyCode = '' then
            Currency.InitRoundingPrecision()
        else begin
            Currency.Get(CurrencyCode);
            Currency.TestField("Amount Rounding Precision");
        end;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
    end;

    procedure updateprepayment(Line: Record MiiTabScheduleLine)
    var
        SH: record "Sales Header";
        SalesLine: Record "Sales Line";
        Prepay: Codeunit Prepay;
        Header: Record MiiTabScheduleHeader;
    begin
        SH.SetFilter("No.", Line."Document No.");
        SH.SetRange("Document Type", SH."Document Type"::"Blanket Order");
        SH.FindFirst();
        Prepay.Code(SH, 0, Line);
    end;


    procedure ProcessPosting(Line: Record MiiTabScheduleLine)
    var
        SH: record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SH.SetFilter("No.", Line."Document No.");
        SH.SetRange("Document Type", SH."Document Type"::"Blanket Order");
        SH.FindFirst();
        InsertInvoiceHeader(SH, Line);

    end;

    procedure InsertInvoiceHeader(SalesHeader: Record "Sales Header"; Line: Record MiiTabScheduleLine)
    var
        SHI: record "Sales Header";
        NoSeries: Codeunit "No. Series";
        SalesLine: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post (Yes/No)";
    begin
        SHI.Init();
        SHI."No. Series" := 'S-PREP';
        SHI."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        SHI."Sell-to Customer Name" := SalesHeader."Sell-to Customer Name";
        SHI."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
        SHI."Bill-to Name" := SalesHeader."Bill-to Name";
        SHI."Posting Description" := 'Installment' + SalesHeader."No.";
        SHI."Payment Terms Code" := SalesHeader."Payment Terms Code";
        SHI."Due Date" := SalesHeader."Due Date";
        SHI."No." := NoSeries.GetNextNo('S-PREP');
        SHI."Document Type" := SHI."Document Type"::Invoice;
        SHI."Document Date" := SalesHeader."Document Date";
        SHI."Posting Date" := Today();
        SHI.Insert();

        SalesLine.SetFilter("Document No.", Line."Document No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Blanket Order");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindSet() then begin
            InsertInvoiceLine(SalesLine, SHI, Line);
        end;
        //PostSalesOrder(CODEUNIT::"Sales-Post (Yes/No)"
        //SalesPost.Run(SalesHeader);

        SHI.SendToPosting(81);
    end;

    procedure InsertInvoiceLine(SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Line: Record MiiTabScheduleLine)
    var
        SLI: Record "Sales Line";
        GenPost: Record "General Posting Setup";
        GLNo: Code[20];
    begin
        GenPost.SetFilter("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
        GenPost.SetFilter("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
        if GenPost.FindFirst() then begin
            GLNo := GenPost."Sales Prepayments Account";
        end;

        SLI.Init();
        SLI."Document Type" := SLI."Document Type"::Invoice;
        SLI."Document No." := SalesHeader."No.";
        SLI."Blanket Order No." := Line."Document No.";
        SLI."Line No." := 10000;
        SLI."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        SLI."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
        SLI.Type := SLI.Type::"G/L Account";
        SLI."No." := GLNo;
        SLI."Posting Date" := SalesHeader."Posting Date";
        SLI.Quantity := 1;
        SLI."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        SLI."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        SLI.Amount := Line.Amount;
        SLI."Amount Including VAT" := Line.Amount;
        SLI.Insert();
    end;

    procedure CopytoOtherCompany(CustLed: Record "Cust. Ledger Entry")
    var
        CLE: Record "Cust. Ledger Entry";
        SourceDCLE: Record "Detailed Cust. Ledg. Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        SourceGLE: Record "G/L Entry";
        GLE: Record "G/L Entry";
        Companies: Record Company;
        CopyToCompany: Text[30];
    begin
        Clear(CopyToCompany);
        Companies.Reset();
        if Page.RunModal(Page::Companies, Companies) = Action::LookupOK then begin
            CopyToCompany := Companies.Name;
        end;

        if CLE.ChangeCompany(CopyToCompany) then begin
            CLE.Init();
            CLE.TransferFields(CustLed);
            CLE.Insert();

            if DCLE.ChangeCompany(CopyToCompany) then begin
                SourceDCLE.SetFilter("Document No.", '%1', CustLed."Document No.");
                if SourceDCLE.FindSet() then begin
                    repeat
                        DCLE.Init();
                        DCLE.TransferFields(SourceDCLE);
                        DCLE.Insert();
                    until SourceDCLE.Next() = 0;
                end;
            end;

            if GLE.ChangeCompany(CopyToCompany) then begin
                SourceGLE.SetFilter("Document No.", '%1', CustLed."Document No.");
                if SourceGLE.FindSet() then begin
                    repeat
                        GLE.Init();
                        GLE.TransferFields(SourceGLE);
                        GLE.Insert();
                    until SourceGLE.Next() = 0;
                end;
            end;
        end;
        Message('Tranfer data to company %1 success', CopyToCompany);
    end;

    procedure deleteCLE(CustLed: Record "Cust. Ledger Entry")
    begin
        CustLed.Delete();
    end;

    var
        DeferSchedOutOfBoundsErr: Label 'The installment schedule falls outside the accounting periods that have been set up for the company.';
        AmountRoundingPrecision: Decimal;
}