pageextension 80110 "G/L Account Card Ext" extends "G/L Account Card"
{
    layout
    {
        addafter("New Page")
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
