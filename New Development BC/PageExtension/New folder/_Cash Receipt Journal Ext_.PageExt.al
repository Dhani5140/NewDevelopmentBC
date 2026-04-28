pageextension 80130 "Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    actions
    {
        addfirst(Reporting)
        {
            action("Print Bukti Bank Masuk")
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Gen. Journal Line";
                begin
                    Rec.TestField(Rec."Document No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Journal Template Name", Rec."Journal Template Name");
                    lRec.SETRANGE(lRec."Journal Batch Name", Rec."Journal Batch Name");
                    lRec.FilterGroup(2);
                    lRec.SETRANGE(lRec."Line No.", Rec."Line No.");
                    lRec.FilterGroup(0);
                    lRec.SETRANGE(lRec."Document No.", Rec."Document No.");

                end;
            }
        }
    }
    var
        myInt: Integer;
}
