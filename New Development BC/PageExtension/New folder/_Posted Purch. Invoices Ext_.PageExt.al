pageextension 80214 "Posted Purch. Invoices Ext" extends "Posted Purchase Invoices"
{
    actions
    {
        addafter("&Print")
        {
            action("Print Jurnal Hutang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Category7;
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
