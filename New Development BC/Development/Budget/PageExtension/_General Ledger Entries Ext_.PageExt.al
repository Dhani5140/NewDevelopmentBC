pageextension 80131 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(BudgetCode; Rec.BudgetCode)
            {
                ApplicationArea = all;
            }
            field(BudgetName; Rec.BudgetName)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(Reporting)
        {
            action("Print Jurnal Umum")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "G/L Entry";
                begin
                    lRec.RESET;
                    lRec.FilterGroup(2);
                    lRec.SETRANGE(lRec."Entry No.", Rec."Entry No.");
                    lRec.FilterGroup(0);
                    lRec.SETRANGE(lRec."Document No.", Rec."Document No.");

                end;
            }
            action("Print Jurnal Penerimaan")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                begin

                end;
            }
            action("Print Jurnal Pengeluaran")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                begin

                end;
            }

        }
    }
    var
        myInt: Integer;
}
