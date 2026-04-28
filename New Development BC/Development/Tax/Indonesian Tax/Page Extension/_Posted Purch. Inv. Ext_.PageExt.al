pageextension 80114 "Posted Purch. Inv. Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = ALL;
                Editable = TRUE;
            }
        }
        addafter("Responsibility Center")
        {
            // field("Shipping Date"; Rec."Shipping Date")
            // {
            //     ApplicationArea = All;
            // }
            field("No. Polisi"; Rec."No. Polisi")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("No. Surat Jalan"; Rec."No. Surat Jalan")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
        }

        addafter(PurchInvLines)
        {
            group("Tax Module")
            {
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
                field(Creditable; Rec.Creditable)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action("Print Jurnal Hutang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Category6;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Purch. Inv. Header";
                begin
                    Rec.TestField(Rec."No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."No.", Rec."No.");

                end;
            }
        }
    }
    var
        myInt: Integer;
}
