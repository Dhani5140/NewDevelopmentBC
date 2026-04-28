pageextension 80147 "Sales Return Order Ext" extends "Sales Return Order"
{
    layout
    {
        addbefore("Invoice Details")
        {
            group("Tax Module")
            {
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
                // field("VAT Registration No."; Rec."VAT Registration No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
            }
        }
        moveafter("Tax No."; "VAT Registration No.")
    }
    var
        myInt: Integer;
}
