pageextension 80119 "Posted Transfer Shipments Ext" extends "Posted Transfer Shipments"
{
    actions
    {
        addafter("&Print")
        {
            action("Print SPB")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Transfer Shipment Header";
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
