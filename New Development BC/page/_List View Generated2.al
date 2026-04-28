page 81117 "List view Generated2"
{
    Caption = 'PageName';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Table View Generate Header";

    layout
    {
        area(Content)
        {
            repeater(general)
            {
                field("Faktur Pajak ID"; Rec."Faktur Pajak ID")
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
}