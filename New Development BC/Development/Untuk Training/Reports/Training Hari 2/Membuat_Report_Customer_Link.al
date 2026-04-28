report 52229 CustomerLink
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomerLink;

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
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");

                column(Document_Type; "Document Type")
                {

                }
                column(Document_No_; "Document No.")
                {

                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {
                group(GroupName)
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
        myInt: Integer;
}