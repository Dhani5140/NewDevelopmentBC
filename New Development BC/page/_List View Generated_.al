page 81116 "List view Generated"
{
    Caption = 'PageName';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Table View Generate Line2";

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Faktur Pajak No"; Rec."Faktur Pajak No")
                {
                    ApplicationArea = all;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        customer: Record Customer;// ini untuk table

}