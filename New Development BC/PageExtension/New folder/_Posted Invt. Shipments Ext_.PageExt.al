pageextension 80123 "Posted Invt. Shipments Ext" extends "Posted Invt. Shipments"
{
    actions
    {
        addafter("&Print")
        {
            action("Print BKB")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Invt. Shipment Header";
                begin
                    Rec.TestField(Rec."No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."No.", Rec."No.");

                end;
            }
        }
    }
    var
        gCUMRFunct: Codeunit "Material Req. Function";
}
