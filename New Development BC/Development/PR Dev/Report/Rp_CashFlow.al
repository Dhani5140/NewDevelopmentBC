report 50118 "Cash Flow by Account"

{
    DefaultLayout = RDLC;
    RDLCLayout = 'CashFlowByAccountdone.rdl';
    Caption = 'Cash Flow by Account';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    PreviewMode = Normal;

    dataset
    {
        dataitem(Header; "Bank Account")
        {
            RequestFilterFields = "No.";
            PrintOnlyIfDetail = true;

            dataitem(CashFlowBuffer; "Cash Flow Buffer")
            {
                DataItemTableView = SORTING("Grouping Account No.", "Posting Date");

                column(CompanyName; COMPANYNAME)
                {

                }
                column(ReportName; 'Cash Flow by Account')
                {

                }
                column(BankName; Header.Name)
                {

                }
                column(DateFilterText; DateFilterText)
                {

                }
                column(GroupingAccountNo; "Grouping Account No.")
                {

                }
                column(GroupingAccountName; "Grouping Account Name")
                {

                }
                column(PostingDate; "Posting Date")
                {

                }
                column(Description_CashFlow; Description)
                {

                }
                column(Amount_CashFlow; Amount)
                {
                    
                }
                column(DocumentTypeText; Format("Document Type"))
                {

                }
            }

            trigger OnAfterGetRecord()
            var
                GLAccount: Record "G/L Account";
                GLEntry: Record "G/L Entry";
                ContraGLEntry: Record "G/L Entry";
                BankAccPostingGroup: Record "Bank Account Posting Group";
                BankGLaac: Code[20];
                CombinedGLFilter: Text;
                LineNo: Integer;
            begin
                CashFlowBuffer.DeleteAll();
                LineNo := 0;

                if not BankAccPostingGroup.Get(Header."Bank Acc. Posting Group") then
                    CurrReport.Skip();
                BankGLaac := BankAccPostingGroup."G/L Account No.";

                GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
                GLEntry.SetRange("G/L Account No.", BankGLaac);

                if DateFilterForGLEntry <> '' then
                    GLEntry.SetFilter("Posting Date", DateFilterForGLEntry);

                if GLEntry.FindSet() then
                    repeat
                        ContraGLEntry.SetCurrentKey("Transaction No.", "Posting Date");
                        ContraGLEntry.SetRange("Transaction No.", GLEntry."Transaction No.");
                        ContraGLEntry.SetRange("Posting Date", GLEntry."Posting Date");

                        CombinedGLFilter := StrSubstNo('<>%1', BankGLaac);
                        if GLAccountFilter <> '' then
                            CombinedGLFilter := CombinedGLFilter + ' & ' + GLAccountFilter;

                        ContraGLEntry.SetFilter("G/L Account No.", CombinedGLFilter);

                        if ContraGLEntry.FindSet() then
                            repeat
                                if not GLAccount.Get(ContraGLEntry."G/L Account No.") then
                                    GLAccount.Name := 'N/A';

                                LineNo += 1;
                                CashFlowBuffer.Init();
                                CashFlowBuffer."Line No." := LineNo;
                                CashFlowBuffer."Grouping Account No." := ContraGLEntry."G/L Account No.";
                                CashFlowBuffer."Grouping Account Name" := GLAccount.Name;
                                CashFlowBuffer."Posting Date" := ContraGLEntry."Posting Date";
                                CashFlowBuffer.Description := ContraGLEntry.Description;
                                CashFlowBuffer.Amount := ContraGLEntry.Amount;
                                CashFlowBuffer."Document Type" := ContraGLEntry."Document Type";
                                CashFlowBuffer.Insert();
                            until ContraGLEntry.Next() = 0;
                    until GLEntry.Next() = 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PeriodDateFilter; PeriodDateFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Filter';

                    }
                    field(GLAccountFilter; GLAccountFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Grouping Account Filter';
                        TableRelation = "G/L Account";
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        StartDate, EndDate : Date;
        Month, Year : Integer;
        MonthText, YearText : Text;
        SlashPos: Integer;
        IsParsedAsPeriod: Boolean;
    begin
        if PeriodDateFilter = '' then begin
            DateFilterForGLEntry := '';
            DateFilterText := 'All Dates';
        end else begin
            IsParsedAsPeriod := false;

            SlashPos := StrPos(PeriodDateFilter, '/');
            if (SlashPos > 0) then begin
                MonthText := CopyStr(PeriodDateFilter, 1, SlashPos - 1);
                YearText := CopyStr(PeriodDateFilter, SlashPos + 1);
                if Evaluate(Month, MonthText) and Evaluate(Year, YearText) then
                    if (Month in [1 .. 12]) and (Year > 0) then
                        IsParsedAsPeriod := true;
            end else if (StrLen(PeriodDateFilter) = 6) then begin
                MonthText := CopyStr(PeriodDateFilter, 1, 2);
                YearText := CopyStr(PeriodDateFilter, 3, 4);
                if Evaluate(Month, MonthText) and Evaluate(Year, YearText) then
                    if (Month in [1 .. 12]) and (Year > 0) then
                        IsParsedAsPeriod := true;
            end;

            if IsParsedAsPeriod then begin
                StartDate := DMY2Date(1, Month, Year);
                EndDate := CalcDate('<CM>', StartDate);
                DateFilterForGLEntry := Format(StartDate) + '..' + Format(EndDate);
                DateFilterText := 'Period ' + Format(StartDate, 0, '<Month Text, 4> <Year4>');
            end else begin
                DateFilterForGLEntry := PeriodDateFilter;
                DateFilterText := PeriodDateFilter;
            end;
        end;
    end;

    var
        PeriodDateFilter: Text;
        DateFilterForGLEntry: Text;
        DateFilterText: Text;
        GLAccountFilter: Text;
}
