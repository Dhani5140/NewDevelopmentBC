pageextension 80106 "Posted Purch. Rcpt. Ext" extends "Posted Purchase Receipt"
{
    layout
    {
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
    }
    actions
    {
        addafter("&Print")
        {
            action("Print Bukti Penerimaan Barang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Purch. Rcpt. Header";
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
