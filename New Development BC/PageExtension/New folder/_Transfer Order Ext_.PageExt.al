pageextension 80117 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        addafter(Status)
        {
            field("Purchase Req. No."; Rec."Purchase Req. No.")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
        }
    }
    var
        myInt: Integer;
}
