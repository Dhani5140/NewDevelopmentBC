pageextension 60100 GLBudget extends "G/L Budget Entries"
{
    layout
    {
        addafter(Description)
        {
            field(BudgetName; Rec.BudgetName)
            {
                ApplicationArea = all;
            }
            field(BudgetCode; Rec.BudgetCode)
            {
                ApplicationArea = all;
            }
            field(StatusBudget; Rec.StatusBudget)
            {
                ApplicationArea = all;
            }
        }

        addafter(Amount)
        {
            field(Realized; Rec.Realized)
            {
                ApplicationArea = all;
            }
            field(Remaining; Rec.Remaining)
            {
                ApplicationArea = all;
            }

        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        rec.Status := rec.Status::"Not Sync";
        rec.Modify();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        rec.Remaining := rec.Amount - rec.Realized;
    end;

    trigger OnAfterGetRecord()
    begin

    end;
}