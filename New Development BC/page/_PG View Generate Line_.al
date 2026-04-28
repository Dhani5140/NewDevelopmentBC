page 81113 "View Generete Pajak Line"
{
    PageType = ListPart;
    AutoSplitKey = true;
    DelayedInsert = true;
    RefreshOnActivate = true;
    SourceTable = "Table View Generate Line2";
    caption = 'New Generate Pajak';
    // Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Faktur Pajak No"; Rec."Faktur Pajak No")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Bill-to / Pay-To No."; Rec."Bill-to / Pay-To No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No1"; Rec."Document No1")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                // field("Transaction Code"; Rec."Transaction Code")
                // {
                //     ApplicationArea = all;
                // }
                // field("Branch Code"; Rec."Branch Code")
                // {
                //     ApplicationArea = all;
                // }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin

            //     end;
            // }
            action(Related)
            {
                ApplicationArea = all;
                Caption = 'Related Document Pajak Keluaran';
                Image = RelatedInformation;

                trigger OnAction()
                var
                    sales: Record "ID Sales Tax Mgmt1";
                //line: Record "Table View Generate Line2";
                begin
                    sales.SetRange("No.", Rec."Document No1");
                    page.Run(page::"ID Sales Tax Document Mgmt", sales);
                end;
            }
        }
    }

    var
        myInt: Integer;


    trigger OnModifyRecord(): Boolean
    var
        HeaderRec: Record "Table View Generate Header";
    begin
        // Setelah line diubah, panggil CheckAndUpdateStatus di header
        if HeaderRec.Get(Rec."Document No.") then begin
            HeaderRec.CheckAndUpdateStatus(); // Prosedur global sekarang bisa diakses
        end;
        exit(true); // Lanjutkan modifikasi record
    end;


}