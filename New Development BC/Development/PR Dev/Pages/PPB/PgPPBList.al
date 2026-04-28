namespace PR.PPB;

using Microsoft.Foundation.Attachment;

page 60108 "PPB List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Purchase Request';
    CardPageID = PPBForm;
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = PPBHeader;
    RefreshOnActivate = true;
    Permissions = TableData PPBHeader = rimd;
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
                field("No. PB"; Rec."No. PB")
                {
                    ApplicationArea = suite;
                }
                field("PB Date"; Rec."PB Date")
                {
                    ApplicationArea = suite;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = all;
                }
                field(Departement; Rec.Departement)
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
        area(Processing)
        {
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

