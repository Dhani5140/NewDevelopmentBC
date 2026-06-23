namespace PR.PB;
using Microsoft.Foundation.Attachment;

page 60105 "PB Header (Warehouse)"
{
    Caption = 'Material Request Deliver';
    RefreshOnActivate = true;
    PageType = Document;
    SourceTable = PBHeader;
    SourceTableView = where(Status = filter(Released));


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ApplicationArea = suite;

                }
                field("Request Date"; Rec."Request Date")
                {
                    Importance = Promoted;
                    ApplicationArea = suite;
                }
                field(Departement; Rec.Departement)
                {
                    Importance = Promoted;
                    ApplicationArea = suite;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Importance = Promoted;
                    ApplicationArea = suite;
                }
                field("Spare Part"; Rec."Spare Part")
                {
                    Caption = 'Jenis Alat';
                    ApplicationArea = all;
                    Importance = Promoted;
                }

                field(Requester; Rec.Requester)
                {
                    Caption = 'Requester';
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field(Keperluan; Rec.Keperluan)
                {
                    Caption = 'Untuk Keperluan';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    Editable = false;
                    ApplicationArea = all;
                }

            }
            part(PbListWar; PBDetailwar)
            {
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = Suite;
            }


        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                Caption = 'Attachment';
                SubPageLink = "Table ID" = const(60100),
                                "No." = field("No.");
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Transppb)
            {

                ApplicationArea = Suite;
                Caption = 'Transfer PPB';
                Ellipsis = true;
                Image = TransferOrder;

                trigger OnAction()
                begin
                    Rec.TransferPPB();
                end;
            }

            action(Dliver)
            {

                ApplicationArea = Suite;
                Caption = 'Deliver Item';
                Ellipsis = true;
                Image = NegativeLines;

                trigger OnAction()
                begin
                    Rec.DeliverItem();
                end;
            }


        }
        area(Reporting)
        {

            action(Doc)
            {

                ApplicationArea = Suite;
                Caption = 'Document PB';
                Ellipsis = true;
                Image = Print;

                trigger OnAction()
                begin
                    rec.SetRange("No.", rec."No.");
                    Report.run(60100, true, false, Rec)

                end;
            }


        }
    }
}