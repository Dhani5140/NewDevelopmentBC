report 53338 Customer_CusledEnt23
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomerLink;
    Caption = 'Customer Link2';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {


            column(Posting_Date; "Posting Date")
            {

            }
            column(Customer_No_; "Customer No.")
            {

            }
            column(Document_Type; "Document Type")
            {

            }
            column(Document_No_; "Document No.")
            {

            }

            dataitem(Customer; Customer)
            {
                DataItemLinkReference = "Cust. Ledger Entry";
                DataItemLink = "No." = field("Customer No.");
                column(No_; "No.")
                {

                }

                column(Address; Address)
                {

                }


            }

            trigger OnAfterGetRecord()
            var
                user: Record User;
            begin
                "Cust. Ledger Entry".SetRange("Posting Date", fromDate, todate);
            end;






        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                // Grup untuk opsi filter tanggal
                group(filter)
                {
                    field(fromDate; fromDate)
                    {

                    }

                    field(toDate; toDate)
                    {

                    }

                }
            }
        }


        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    rendering
    {
        layout(CustomerLink)
        {
            Type = RDLC;
            LayoutFile = 'CustomerLink2.rdl';
        }
    }


    var
        fromDate: Date;
        toDate: date;

}