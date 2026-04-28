tableextension 60102 MyExtension extends "G/L Budget Entry"
{
    fields
    {
        field(50000; Status; Enum Status)
        {

        }
        field(60100; BudgetName; Text[50])
        {
            Caption = 'Budget Name';
        }
        field(60101; BudgetCode; Text[50])
        {
            Caption = 'Budget Code';
        }
        field(60102; StatusBudget; Enum StatusBR)
        {
            Caption = 'Status';
        }
        field(60103; Realized; Decimal)
        {
            Caption = 'Realized  Amount';
        }
        field(60104; Remaining; Decimal)
        {
            Caption = 'Remaining Amount';
        }
    }
}
