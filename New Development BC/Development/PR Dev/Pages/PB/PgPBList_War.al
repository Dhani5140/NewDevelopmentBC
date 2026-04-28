namespace PR.PB;


page 60104 "PB List (Warehouse)"
{
    Caption = 'Material Request Deliver';
    ApplicationArea = basic, suite;
    DataCaptionFields = "No.";
    CardPageId = "PB Header (Warehouse)";
    Editable = false;
    RefreshOnActivate = true;
    PageType = List;
    SourceTable = PBHeader;
    UsageCategory = Lists;
    QueryCategory = 'PB List (Non Warehouse)';
    SourceTableView = where(Status = filter(Released));


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
                    Caption = 'Jenis Alat';
                    ApplicationArea = Suite;
                }
                field(Keperluan; Rec.Keperluan)
                {
                    Caption = 'Untuk Keperluan';
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

