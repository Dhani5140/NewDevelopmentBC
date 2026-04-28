pageextension 80115 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    actions
    {
        addafter(Print)
        {
            action("Print Jurnal Piutang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Category7;
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
