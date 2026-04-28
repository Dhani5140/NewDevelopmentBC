namespace PR.PB;

page 60100 "PB List (Non Warehouse)"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Material Request';
    CardPageID = PBForm;
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = PBHeader;
    RefreshOnActivate = true;
    Permissions = TableData PBHeader = rimd;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = Suite;
                }
                field(Departement; Rec.Departement)
                {
                    ApplicationArea = Suite;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = Suite;
                }
                field("Spare Part"; Rec."Spare Part")
                {
                    ApplicationArea = Suite;
                }
                field(Keperluan; Rec.Keperluan)
                {
                    ApplicationArea = Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                }
            }
        }
    }
    actions
    {

    }
}

