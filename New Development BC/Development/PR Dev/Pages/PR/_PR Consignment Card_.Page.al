page 80130 "PR Consignment Card"
{
    PageType = Card;
    SourceTable = "PR Consignment Header";
    ApplicationArea = All;
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
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
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
                field(isPosted; Rec.isPosted)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("BPB No."; Rec."BPB No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
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
                    Editable = FALSE;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '1,2,2';
                    Editable = FALSE;
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
            part("PR Consignment Subform"; "PR Consignment Subform")
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
                SubPageLink = "Table ID" = CONST(database::"PR Consignment Header"), "No." = FIELD("Purchase Req. No.");
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
                            gCUApproval_PR.OnSendforApproval_PRCons(Rec)
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
                        gCUApproval_PR.OnCancelforApproval_PRCons(Rec);
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
                    lRec: Record "PR Consignment Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Purchase Req. No.", Rec."Purchase Req. No.");

                end;
            }
            action("Post&Print")
            {
                Caption = 'Post & Print';
                ApplicationArea = All;
                Image = PostPrint;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "PR Consignment Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");

                end;
            }
            action("Cancel&Reverse Post")
            {
                Caption = 'Cancel & Reverse Post';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "PR Consignment Header";
                    lRecUserSetup: Record "User Setup";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    IF Rec.Status IN [Rec.Status::Released] = FALSE THEN ERROR('Status must be released to cancel post');
                    IF Rec.isPosted = FALSE THEN ERROR('This document has not been posted, cannot cancel post');
                    IF Rec."BPB No." = '' THEN ERROR('This document has not been posted, cannot cancel post');
                    lRecUserSetup.RESET;
                    lRecUserSetup.SETRANGE(lRecUserSetup."User ID", USERID);
                    IF lRecUserSetup.FINDFIRST THEN BEGIN
                        IF lRecUserSetup."Allow Cancel PR Consignment" = FALSE THEN ERROR('You are not allowed to cancel PR Consignment');
                    END
                    ELSE BEGIN
                        ERROR('User setup for %1 is not found', USERID);
                    END;


                end;
            }
            // action("Cancel Test")
            // {
            //     ApplicationArea = All;
            //     Image = Cancel;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     PromotedIsBig = TRUE;
            //     trigger OnAction()
            //     var
            //         lRecPRLine: Record "PR Consignment Line";
            //         lRecMRLine: Record "MR Consignment Line";
            //         gCUMRFunct: Codeunit "MR Consignment Function";
            //     begin
            //         Rec.isPosted := FALSE;
            //         Rec."BPB No." := '';
            //         Rec."Posting Date" := 0D;
            //         Rec.Status := Rec.Status::Canceled;
            //         Rec.MODIFY;
            //         //wait autoposting 
            //         // lRecGJL.SendToPosting(Codeunit::"Gen. Jnl.-Post");
            //         COMMIT;
            //         lRecPRLine.RESET;
            //         lRecPRLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
            //         IF lRecPRLine.FIND('-') THEN BEGIN
            //             REPEAT
            //                 // lRecPRLine."BPB No." := '';
            //                 lRecPRLine.Cancel := TRUE;
            //                 lRecPRLine.MODIFY;
            //             UNTIL lRecPRLine.NEXT = 0;
            //         END;
            //         COMMIT;
            //         lRecPRLine.RESET;
            //         lRecPRLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
            //         lRecPRLine.SETFILTER(Quantity, '<>%1', 0);
            //         IF lRecPRLine.FIND('-') THEN BEGIN
            //             REPEAT
            //                 IF (lRecPRLine."Material Req. No." <> '') AND (lRecPRLine."Material Req. Line No." <> 0) THEN BEGIN
            //                     lRecMRLine.RESET;
            //                     lRecMRLine.SETRANGE("Material Req. No.", lRecPRLine."Material Req. No.");
            //                     lRecMRLine.SETRANGE("Line No.", lRecPRLine."Material Req. Line No.");
            //                     IF lRecMRLine.FINDFIRST THEN BEGIN
            //                         gCUMRFunct.updOutstandingQtyMR(lRecMRLine, lRecPRLine.RecordID, -lRecPRLine.Quantity);
            //                     END;
            //                 END;
            //             UNTIL lRecPRLine.NEXT = 0;
            //         END;
            //         CurrPage.UPDATE;
            //     end;
            // }

        }
    }
    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
    end;

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     CurrPage.SaveRecord();
    //     CurrPage.Update;
    // end;
    var
        grecPurchaseReqLine: Record "PR Consignment Line";
        gCUApproval_PR: Codeunit "PR Consignment Approval";

        gStyleItemNo: Text[100];
        gBolEditable: Boolean;
}
