pageextension 80143 "Purch. Cr. Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter(PurchLines)
        {
            group("Tax Module")
            {
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
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
                field(Creditable; Rec.Creditable)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        myInt: Integer;
}
