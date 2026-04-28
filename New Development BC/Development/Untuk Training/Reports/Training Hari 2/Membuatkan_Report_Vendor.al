report 52223 Vendor
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "Report Vendor";
    Caption = 'Vendor Dasar';

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

            column(Name_2; "Name 2")
            {

            }

            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = Vendor;
                DataItemLink = "Vendor No." = field("No.");

                column(Original_Amount; "Original Amount")
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
                action(vendor)
                {

                }
            }
        }
    }

    rendering
    {
        layout("Report Vendor")
        {
            Type = RDLC;
            LayoutFile = 'Report/Layout/Vendor.rdl';
        }
    }

    var
        myInt: Integer;
}