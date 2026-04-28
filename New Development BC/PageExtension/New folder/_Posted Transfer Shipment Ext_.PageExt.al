pageextension 80120 "Posted Transfer Shipment Ext" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("Transfer Order No.")
        {
            field("Purchase Req. No."; Rec."Purchase Req. No.")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
        }
    }
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
