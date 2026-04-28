pageextension 80101 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
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
        addafter("External Document No.")
        {
            field("No. Shipping"; Rec."No. Shipping")
            {
                ApplicationArea = ALL;
                Editable = FALSE;
            }
            field("No. Berita Acara"; Rec."No. Berita Acara")
            {
                ApplicationArea = ALL;
                Editable = FALSE;
            }
        }
        addafter(General)
        {
            group("Tax Module")
            {
                field("Tax-Document Post"; Rec."Tax-Document Post")
                {
                    ApplicationArea = All;
                }
                field("Transaction Code"; Rec."Transaction COde")
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
                // field("VAT Registration No."; Rec."VAT Registration No.")
                // {
                //     ApplicationArea = All;
                // }
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
                field("No. KTP"; Rec."No. KTP")
                {
                    ApplicationArea = All;
                }
            }
        }
        moveafter("Tax No."; "VAT Registration No.")
    }
    actions
    {
        addafter(Print)
        {
            action("Print Jurnal Piutang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Category6;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Sales Invoice Header";
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
