namespace PR;

page 60107 PageAnalisis
{
    Caption = 'Page Analisis Expense';
    ApplicationArea = all;
    Editable = true;
    UsageCategory = Administration;
    PageType = List;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    RefreshOnActivate = true;
    Permissions = TableData Analisispage = rmid;
    SourceTable = Analisispage;
    AdditionalSearchTerms = 'Page Analisis Expense';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = all;
                }
                field("Dept Code"; Rec."Dept Code")
                {
                    ApplicationArea = all;
                }
                field(COA; Rec.COA)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
