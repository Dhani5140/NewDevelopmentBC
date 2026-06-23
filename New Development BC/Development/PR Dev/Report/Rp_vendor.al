report 50119 "Vendor Statement"
{
    Caption = 'Vendor Statement';
    DefaultRenderingLayout = "Vendor Statement";
    UsageCategory = ReportsAndAnalysis;



    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(VendorNo; "No.")
            {

            }

            column(VendorName; Name)
            {

            }

            column(Address1; Address)
            {

            }
            column(Address2; "Address 2")
            {

            }
            column(Contact; Contact)
            {

            }
            column(Phone_No_; "Phone No.")
            {

            }
            column(Fax_No_; "Fax No.")
            {

            }
            column(E_Mail; "E-Mail")
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }
            column(CompanyInfo; CompanyInfo.Name)
            {

            }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No.");
                DataItemTableView = sorting("Vendor No.", "Posting Date", "Entry No.");

                RequestFilterFields = "Posting Date";

                column(Document_No_; "Document No.")
                {

                }

                column(Posting_Date; "Posting Date")
                {

                }
                column(Description; Description)
                {

                }
                column(increase; "Credit Amount")
                {

                }

                column(decrease; "Debit Amount")
                {

                }

                //Ditanya Ulang ke Functional
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)")
                {

                }
                trigger OnPreDataItem()
                begin

                    if DateFilter <> '' then
                        SetFilter("Posting Date", DateFilter);
                end;

                trigger OnAfterGetRecord()
                begin
                    TotalIncrease += "Credit Amount";
                    TotalDecrease += "Debit Amount";

                    if FirstLineWithinFilter then begin
                        OpeningBalance := "Remaining Amt. (LCY)";
                        FirstLineWithinFilter := false;

                    end;
                    EndingBalance := "Remaining Amount";
                end;


            }
            //    dataitem("G/L Entry";"G/L Entry")
            //    {
            //     DataItemLink = "Source No." = field("No.");
            //     DataItemTableView = sorting("Source No.", "Posting Date", "Entry No.");

            //     column(Document_Type;"Document Type")
            //     {

            //     }

            //     column(Posting_Date;"Posting Date")
            //     {

            //     }
            //     column(Amount;Amount)
            //     {

            //     }
            //     column(Description;Description)
            //     {

            //     }

            //    }

            trigger OnAfterGetRecord()
            begin
                NetChange := TotalIncrease - TotalDecrease;
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

                    field(DateFilter; DateFilter)
                    {
                        Caption = 'Date Filter';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin


                        end;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {

            }
        }
    }

    rendering
    {
        layout("Vendor Statement")
        {
            Type = RDLC;
            LayoutFile = 'vendorStatement.rdl';
        }
    }



    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        VendorRec: Record Vendor;
        DateFilter: Text[50];
        OpeningBalance: Decimal;
        TotalIncrease: Decimal;
        TotalDecrease: Decimal;
        NetChange: Decimal;
        EndingBalance: Decimal;
        FirstLineWithinFilter: Boolean;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
    end;

    local procedure GetDateFilterText(): Text[100]
    var
        Vend: Record Vendor;
    begin
        Vend.copy(VendorRec);
        exit(Vend.GetFilter("Date Filter"));
    end;
}