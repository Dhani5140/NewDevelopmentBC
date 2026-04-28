report 52224 MyReportexcel
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ExcelReportCustomer;

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
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
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
        layout(ExcelReportCustomer)
        {
            Type = Excel;
            LayoutFile = 'mySpreadsheet2.xlsx';
        }
    }

    var
        myInt: Integer;
}