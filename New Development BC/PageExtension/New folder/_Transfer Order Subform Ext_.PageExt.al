pageextension 80118 "Transfer Order Subform Ext" extends "Transfer Order Subform"
{
    layout
    {
        modify("Qty. to Ship")
        {
            Editable = FALSE;
        }
        modify("Qty. to Receive")
        {
            Editable = FALSE;
        }
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
