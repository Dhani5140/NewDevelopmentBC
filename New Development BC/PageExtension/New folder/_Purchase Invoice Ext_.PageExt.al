pageextension 80145 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        addbefore(PurchLines)
        {
            group("Tax Module")
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
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
                field("NPWP Address 2"; Rec."NPWP Address 2")
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
