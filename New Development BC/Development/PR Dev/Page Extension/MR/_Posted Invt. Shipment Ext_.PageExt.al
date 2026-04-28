pageextension 80124 "Posted Invt. Shipment Ext" extends "Posted Invt. Shipment"
{
    layout
    {
        addafter("Location Code")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("MR Usage Category"; Rec."MR Usage Category")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("Unit Group"; Rec."Unit Group")
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
