pageextension 80122 "Item Ledger Entries Ext" extends "Item Ledger Entries"
{
    actions
    {
        addfirst(Reporting)
        {
            action("Print Summary BKB")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = TRUE;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Item Ledger Entry";
                begin
                    Rec.TestField(Rec."Document No.");
                    lRec.RESET;
                    lRec.FilterGroup(2);
                    lRec.SETRANGE(lRec."Entry No.", Rec."Entry No.");
                    lRec.FilterGroup(0);
                    lRec.SETRANGE(lRec."Document No.", Rec."Document No.");

                end;
            }
        }
    }
    var
        myInt: Integer;
}
