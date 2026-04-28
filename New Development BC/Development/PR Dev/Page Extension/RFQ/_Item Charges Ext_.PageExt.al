pageextension 80113 "Item Charges Ext" extends "Item Charges"
{
    layout
    {

        addafter("Search Description")
        {
            field("Shipping Charge RFQ"; Rec."Shipping Charge RFQ")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;
}
