page 80127 "MR Consignment Card"
{
    ApplicationArea = All;
    PromotedActionCategoriesML = ENU = 'New,Process,Report,Approval Request,Action Approval';
    PageType = Card;
    SourceTable = "MR Consignment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;

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
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = ALL;
                    Editable = FALSE;
                }
                field("Requester Name"; Rec."Requester Name")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                }
                field("Requester Department"; Rec."Requester Department")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,1';
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,3';
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;
                }
                field("MR Usage Category"; Rec."MR Usage Category")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,5';
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Unit Group"; Rec."Unit Group")
                {
                    ApplicationArea = ALL;
                    Editable = FALSE;
                }
                field("Gen Bus. Posting Group"; Rec."Gen Bus. Posting Group")
                {
                    ApplicationArea = ALL;
                    Editable = FALSE;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = ALL;
                    Editable = gBolEditable;
                    MultiLine = TRUE;
                }
            }
            group(Dimension)
            {
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,2';
                    Editable = gBolEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,4';
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
            part("MR Consignment Subform"; "MR Consignment Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Material Req. No." = field("Material Req. No.");
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"MR Consignment Header"), "No." = FIELD("Material Req. No.");
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
                    var
                        lrecMRLine: Record "MR Consignment Line";
                        lCUApproval_MR: Codeunit "MR Consignment Approval";
                    begin
                        Rec.TestField("Status", Rec."Status"::Open);
                        // Rec."Status" := Rec."Status"::"Pending Approval";
                        gCUMRFunct.checkMandatoryFields(Rec);
                        IF lCUApproval_MR.CheckWorkflowEnabled(Rec) THEN
                            lCUApproval_MR.OnSendforApproval_MRCons(Rec)
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
                    var
                        lCUApproval_MR: Codeunit "MR Consignment Approval";
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        lCUApproval_MR.OnCancelforApproval_MRCons(Rec);
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
                        // IF rec."Over Budget" AND (Rec."Over Budget Approved" = FALSE) then begin
                        //     ERROR('Please Request Approval first because there is line over budget.');
                        // end;
                        IF Rec.Status IN [Rec.Status::Open] = FALSE THEN ERROR('Status must be open to Release');
                        IF NOT gCUApproval_MR.IsEnabled_Custom(Rec) THEN BEGIN
                            gCUMRFunct.checkMandatoryFields(Rec);
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
                        lCUMRFunct: Codeunit "MR Consignment Function";
                    begin
                        IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
                            ERROR('Please Cancel Send Approval to reopen');
                        END;
                        lCUMRFunct.checkMRLinehasPR(Rec."Material Req. No.", 'reopen');
                        // Rec.TestField("Status", Rec."Status"::Released);
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
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "MR Consignment Header";
                begin
                    Rec.TestField(Rec."Material Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Material Req. No.", Rec."Material Req. No.");

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
    end;
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;
    var
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        gCUMRFunct: Codeunit "MR Consignment Function";
        gCUApproval_MR: Codeunit "MR Consignment Approval";
        gBolEditable: Boolean;
}
