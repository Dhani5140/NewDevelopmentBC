pageextension 80121 "Posted Tr. Shpt. Subform Ext" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Reference No."; Rec."Reference No.")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
        }
    }
    var
        myInt: Integer;
}
