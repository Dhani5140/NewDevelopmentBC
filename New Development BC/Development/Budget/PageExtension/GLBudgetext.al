pageextension 60100 GLBudget extends "G/L Budget Entries"
{
    layout
    {
        addafter(Description)
        {
            field(BudgetName; Rec.BudgetName)
            {

            }
            field(BudgetCode; Rec.BudgetCode)
            {

            }
            field(StatusBudget; Rec.StatusBudget)
            {

            }
        }

        addafter(Amount)
        {
            field(Realized; Rec.Realized)
            {

            }
            field(Remaining; Rec.Remaining)
            {

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