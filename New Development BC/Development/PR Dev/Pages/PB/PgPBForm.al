namespace PR.PB;
using System.Automation;
using Microsoft.Foundation.Attachment;

page 60101 "PBForm"
{
    Caption = 'Material Request';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = PBHeader;
    UsageCategory = Tasks;
    PromotedActionCategories = 'New, Process, Report, Attachments';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field(Departement; Rec.Departement)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("Spare Part"; Rec."Spare Part")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                }
                field(Keperluan; Rec.Keperluan)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = false;
                }
            }
            part(PBList; PBDetail)
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(Database::PBHeader),
                                "No." = field("No.");
                Visible = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    ApplicationArea = All;
                    Image = Approve;
                    Visible = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                    end;
                }
            }
            action(DocAttach)
            {
                Caption = 'Upload Attachments';
                ApplicationArea = All;
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
    }

}
