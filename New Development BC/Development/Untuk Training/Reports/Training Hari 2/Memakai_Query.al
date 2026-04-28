report 53339 customerquery
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(No_; Query.No_)
            {
            }
            column(Name; query.Name)
            { }

            trigger OnPreDataItem()
            begin
                Query.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                if not Query.Read() then
                    CurrReport.Break();
            end;

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
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Contoh_report_query.rdl';
        }
    }

    var
        myInt: Integer;
        Query: query Customer;
}