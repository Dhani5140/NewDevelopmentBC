report 52225 CustomerDasar
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomerDasar;



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
        layout(CustomerDasar)
        {
            Type = RDLC;
            LayoutFile = 'Customer_Dasar.rdl';
        }
    }

    var
        myInt: Integer;
}