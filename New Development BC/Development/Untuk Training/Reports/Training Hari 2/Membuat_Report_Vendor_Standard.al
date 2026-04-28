report 52226 vendorDasar
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = VendorDasar;
    Caption = 'Vendor Dasar Test';



    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
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
        }

    }




    requestpage
    {

        layout
        {
            area(Content)
            {
                group(Vendor)
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
        layout(VendorDasar)
        {
            Type = RDLC;
            LayoutFile = 'Vendor_Dasar.rdl';
        }
    }

    var
        myInt: Integer;

        VendorNo: Code[20];


}