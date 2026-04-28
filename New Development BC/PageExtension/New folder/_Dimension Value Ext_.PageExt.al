pageextension 80125 "Dimension Value Ext" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field("Unit Group Dimension"; Rec."Unit Group Dimension")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
        }
    }
    var
        myInt: Integer;
}
