page 80117 "PR Asset Card"
{
    PageType = Card;
    SourceTable = "PR Asset Header";
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval Request,Action Approval';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then begin
                            CurrPage.UPDATE();
                        end;
                    end;
                }
                field("Urgent Status"; Rec."Urgent Status")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    StyleExpr = gStyleItemNo;

                    trigger OnValidate()
                    begin
                        gStyleItemNo := gCUPRFunct.changeColorStyleUrgent(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Requester Name"; Rec."Requester Name")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Payment Terms Name"; Rec."Payment Terms Name")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    MultiLine = TRUE;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group(Dimension)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,2';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,3';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,4';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,5';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,6';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,7';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,8';
                    Editable = gBolEditable;
                }
            }
            part("PR Asset Subform"; "PR Asset Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Purchase Req. No." = field("Purchase Req. No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"PR Asset Header"), "No." = FIELD("Purchase Req. No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("Approval Request")
            {
                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::Open);
                        IF gCUApproval_PR.CheckWorkflowEnabled(Rec) THEN
                            gCUApproval_PR.OnSendforApproval_PRAsset(Rec)
                        ELSE
                            Message('Approval has been sent.');
                        CurrPage.UPDATE();
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    // Enabled = CanCancelApprovalforRecord OR CanCancelApprovalforFlow;
                    Promoted = True;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        gCUApproval_PR.OnCancelforApproval_PRAsset(Rec);
                    end;
                }
                action("Approved")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = Approve;
                    Visible = FALSE;

                    trigger OnAction()
                    var
                        lrecUserSetup: Record "User Setup";
                    begin
                        Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        Rec.VALIDATE("Status", Rec."Status"::Released);
                        CurrPage.UPDATE();
                        Message('Document has been approved.');
                    end;
                }
                action("Reject")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = Reject;
                    Visible = FALSE;

                    trigger OnAction()
                    begin
                        Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        Rec."Status" := Rec."Status"::"Open";
                        CurrPage.UPDATE();
                        Message('Document has been rejected.');
                    end;
                }
                action("Release")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        // Rec.TestField("Status", Rec."Status"::"Pending Approval");
                        //Rec.CalcFields("Over Budget");
                        IF Rec.Status IN [Rec.Status::Open] = FALSE THEN ERROR('Status must be open to Release');
                        IF NOT gCUApproval_PR.IsEnabled_Custom(Rec) THEN BEGIN
                            Rec.VALIDATE("Status", Rec."Status"::Released);
                            CurrPage.UPDATE();
                            Message('Document has been released');
                        END
                        ELSE BEGIN
                            ERROR('Workflow for this record data type is enabled, cannot manually release');
                        END;
                    end;
                }
                action("Reopen")
                {
                    ApplicationArea = All;
                    Promoted = True;
                    PromotedCategory = Category4;
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        lCUPRFunct: Codeunit "PR Asset Function";
                    begin
                        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                            ERROR('Please Cancel Send Approval to reopen');
                        END;
                        lCUPRFunct.checkPRLinehasPO(Rec."Purchase Req. No.", 0, 'reopen');
                        IF Rec.Status IN [Rec.Status::Released, Rec.Status::Processed] = FALSE THEN ERROR('Status must be released or process to Reopen');
                        Rec.VALIDATE("Status", Rec."Status"::Open);
                        CurrPage.Update();
                        Message('Document has been reopen.');
                    end;
                }
            }
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "PR Asset Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Purchase Req. No.", Rec."Purchase Req. No.");

                end;
            }
            action("Create PO")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocument;

                trigger OnAction()
                var
                    lCUPRFunction: Codeunit "PR Asset Function";
                begin
                    CurrPage.UPDATE();
                    Rec.TestField(Status, Rec.Status::Released);
                    lCUPRFunction.createPOHeader_PRAsset(Rec);
                    CurrPage.UPDATE();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
        END;
        gStyleItemNo := gCUPRFunct.changeColorStyleUrgent(Rec);
    end;

    var
        gCUApproval_PR: Codeunit "PR Asset Approval";
        gCUPRFunct: Codeunit "PR Asset Function";
        gBolEditable: Boolean;
        gStyleItemNo: Text[100];
}
