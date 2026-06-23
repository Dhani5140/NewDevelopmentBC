pageextension 58599 WHRECEIPT extends "Whse. Receipt Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("No Bea Cukai"; Rec."No Bea Cukai")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}