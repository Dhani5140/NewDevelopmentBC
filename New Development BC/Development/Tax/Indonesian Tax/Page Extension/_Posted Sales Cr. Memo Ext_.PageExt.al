pageextension 80142 "Posted Sales Cr. Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter(SalesCrMemoLines)
        {
            group("Tax Module")
            {
                // field("VAT Registration No."; Rec."VAT Registration No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
                field("NPWP Name"; Rec."NPWP Name")
                {
                    ApplicationArea = All;
                }
                field("NPWP Address"; Rec."NPWP Address")
                {
                    ApplicationArea = All;
                }
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
