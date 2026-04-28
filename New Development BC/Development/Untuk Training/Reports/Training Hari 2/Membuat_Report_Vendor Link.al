report 53349 VendorLinkLink
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomerLink;

    dataset
    {
        dataitem(Vendor; Vendor)
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
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = Vendor;
                DataItemLink = "Vendor No." = field("No.");

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
            LayoutFile = 'VendorLink.rdl';
        }
    }

    var
        myInt: Integer;
}