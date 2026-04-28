namespace PR.PPB;

using System.Automation;
using Microsoft.Foundation.Attachment;

page 60109 "PPBForm"
{
    Caption = 'Purchase Request';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = PPBHeader;
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
                field("No. PB"; Rec."No. PB")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("PB Date"; Rec."PB Date")
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
                field("Rencana Penggunaan"; Rec."Rencana Penggunaan")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }

                field("Alasan Investasi"; Rec."Alasan Investasi")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
            }
            part(PPBList; PPBDetail)
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
                SubPageLink = "Table ID" = const(Database::PPBHeader),
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
