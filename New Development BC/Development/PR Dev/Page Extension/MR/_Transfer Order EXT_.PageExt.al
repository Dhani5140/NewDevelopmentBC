pageextension 80224 "Transfer Header Ext MII" extends "Transfer Order"
{
    layout
    {
        addafter("In-Transit Code")
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = All;
            }
        }
    }


}