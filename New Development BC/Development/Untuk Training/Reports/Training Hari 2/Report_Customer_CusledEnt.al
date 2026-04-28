report 53332 Customer_CusledEnt
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomerLink;
    Caption = 'Customer Link';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.")
            {

            }
            column(Name; Name)
            {

            }

            column(City; City)
            {

            }
            column(Balance__LCY_; "Balance (LCY)")
            {

            }
            // Data item untuk Cust. Ledger Entry dengan filter pada Posting Date
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");



                column(Posting_Date; "Posting Date")
                {

                }
                column(Document_Type; "Document Type")
                {

                }
                column(Document_No_; "Document No.")
                {

                }

                trigger OnPreDataItem()
                begin
                    "Cust. Ledger Entry".SetRange("Document Type", "Document Type"::Invoice);
                    Message('hanya melihat yang sudah di invoice');
                end;



            }
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
            LayoutFile = 'CustomerLink.rdl';
        }
    }


    var

}