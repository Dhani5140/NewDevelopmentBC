page 60000 BudgetAPI
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "G/L Budget Entry";
    SourceTableView = where(Status = filter("Not Sync"), BudgetCode = filter(<> ''));
    ModifyAllowed = true;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Budget Name"; rec."BudgetCode")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(COA; rec."G/L Account No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Date; rec.Date)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Budget Code"; rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Departement; rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}