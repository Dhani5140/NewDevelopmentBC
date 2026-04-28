page 81112 "Page view Generate"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Table View Generate Header";
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            group(Header)
            {
                field("Faktur Pajak ID"; Rec."Faktur Pajak ID")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Trasaction Code"; Rec."Trasaction Code")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Branch Code1"; Rec."Branch Code1")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("From No."; Rec."From No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("To No"; Rec."To No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // field("Branch Code1"; Rec."Branch Code1")
                // {
                //     ApplicationArea = all;
                // }
            }
            part("Genereta Line"; "View Generete Pajak Line")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                SubPageLink = "Document No." = field("Faktur Pajak ID");
                UpdatePropagation = Both;



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
            //     Caption = 'Generate';

            //     trigger OnAction()
            //     begin
            //         begin

            //             // CheckAndUpdateStatus();
            //         end;

            //     end;
            // }
            action(Related)
            {
                ApplicationArea = all;
                Caption = 'Related Document generate Pajak';
                Image = RelatedInformation;

                trigger OnAction()
                var
                    GenPajak: Record "Generate Pajak Table2";
                //line: Record "Table View Generate Line2";
                begin
                    GenPajak.SetRange("Faktur Pajak ID", rec."Faktur Pajak ID");
                    page.Run(page::"Generate Pajak Page", GenPajak);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        rec.CheckAndUpdateStatus();
        if Format(Rec."Trasaction Code") <> '' then
            rec.UpdateLinesWithHeaderData();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        rec.UpdateLinesWithHeaderData();
        exit(true); // Allow modification to proceed
    end;


    var
        myInt: Integer;




    // procedure CheckAndUpdateStatus() // Hapus kata "local" agar menjadi global procedure
    // var
    //     LineRec: Record "Table View Generate Line2";
    //     AllUsed: Boolean;
    //     HasFree: Boolean;
    // begin
    //     AllUsed := true;
    //     HasFree := false;

    //     // Cek semua line berdasarkan "Faktur Pajak ID"
    //     LineRec.SetRange("Document No.", Rec."Faktur Pajak ID");
    //     if LineRec.FindSet() then begin
    //         repeat
    //             // Jika ada line yang "Free", set HasFree ke true
    //             if LineRec.Status = LineRec.Status::Free then
    //                 HasFree := true;

    //             // Jika ada line yang tidak "Used", set AllUsed ke false
    //             if LineRec.Status <> LineRec.Status::Used then
    //                 AllUsed := false;

    //         until LineRec.Next() = 0;
    //     end;

    //     // Jika semua line sudah "Used", ubah status header menjadi "Close"
    //     if AllUsed then begin
    //         Rec.Status := Rec.Status::Close;
    //         Rec.Modify();
    //         Message('All lines are used. Status updated to "Close".');
    //     end
    //     // Jika ada line yang "Free", ubah status header menjadi "Open"
    //     else if HasFree then begin
    //         Rec.Status := Rec.Status::Open;
    //         Rec.Modify();
    //         //Message('Some lines are Free. Status updated to "Open".');
    //     end;
    // end;



    // local procedure UpdateLinesWithHeaderData()
    // var
    //     LineRec: Record "Table View Generate Line2";
    // begin
    //     // Filter berdasarkan Document No. dari Header
    //     LineRec.SetRange("Document No.", Rec."Faktur Pajak ID");

    //     if LineRec.FindSet() then begin
    //         repeat
    //             LineRec."Transaction Code" := Rec."Trasaction Code";
    //             LineRec."Branch Code" := Rec."Branch Code1";
    //             LineRec.Modify();
    //         until LineRec.Next() = 0;

    //         //Message('Lines updated with new Transaction Code and Branch Code.');
    //     end else begin
    //         Message('No lines found for the current Faktur Pajak ID.');
    //     end;
    // end;




}