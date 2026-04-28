pageextension 80135 "Posted Purch. Receipts Ext" extends "Posted Purchase Receipts"
{
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
