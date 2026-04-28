pageextension 80111 "Invt. Shipment Ext" extends "Invt. Shipment"
{
    layout
    {
        addafter("Location Code")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("MR Usage Category"; Rec."MR Usage Category")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                Caption = '1,2,5';
                Editable = TRUE;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(5, Rec."Shortcut Dimension 5 Code");
                end;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
            field("Unit Group"; Rec."Unit Group")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = '1,2,3';
                Editable = TRUE;

                trigger OnValidate()
                begin
                    Rec.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                end;
            }
        }
        addafter("External Document No.")
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
        }
        moveafter("Location Code"; "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
    }
    actions
    {
        addlast(processing)
        {
            action("Get Material Req.")
            {
                Caption = 'Get Material Request';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    lRecMRLinePage: Record "Material Req. Line";
                    lRecMRLine: Record "Material Req. Line";
                    lRecMRLineCheck: Record "Material Req. Line";
                    lPageSelectMR: Page "Select MR Line";
                    currMRNo: Code[20];
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    // Rec.TestField("Shortcut Dimension 2 Code");
                    lRecMRLinePage.RESET;
                    lRecMRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecMRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
                    lRecMRLinePage.SETFILTER(Status, '%1|%2', lRecMRLinePage.Status::Released, lRecMRLinePage.Status::Processed);
                    lRecMRLinePage.SETRANGE(Cancel, FALSE);
                    lRecMRLinePage.SETRANGE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                    lRecMRLinePage.SETRANGE("Unit Group", Rec."Unit Group");
                    lRecMRLinePage.SETRANGE("MR Usage Category", Rec."MR Usage Category");
                    IF lRecMRLinePage.FIND('-') THEN BEGIN
                        CLEAR(lPageSelectMR);
                        lPageSelectMR.SetTableView(lRecMRLinePage);
                        lPageSelectMR.LookupMode(true);
                        CASE lPageSelectMR.RUNMODAL() OF
                            ACTION::LookupOK:
                                BEGIN
                                    CurrPage.UPDATE();
                                    lRecMRLine.RESET;
                                    lRecMRLineCheck.RESET;
                                    lPageSelectMR.SetSelectionFilter(lRecMRLine);
                                    lPageSelectMR.SetSelectionFilter(lRecMRLineCheck);
                                    lRecMRLineCheck.SetCurrentKey("Material Req. No.");
                                    lRecMRLineCheck.ASCENDING(TRUE);
                                    IF lRecMRLineCheck.FIND('-') THEN BEGIN
                                        REPEAT
                                            IF (currMRNo <> '') AND (currMRNo <> lRecMRLineCheck."Material Req. No.") THEN BEGIN
                                                ERROR('cannot select more than 1 Material Request No.');
                                            END;
                                            currMRNo := lRecMRLineCheck."Material Req. No.";
                                        UNTIL lRecMRLineCheck.NEXT = 0;
                                    END;
                                    IF lRecMRLine.FIND('-') THEN BEGIN
                                        REPEAT
                                            gCUMRFunct.checkMultipleMR_InvShip(lRecMRLine, Rec."No.");
                                            gCUMRFunct.createInvDocLine_MR(lRecMRLine, Rec."No.");
                                        UNTIL lRecMRLine.NEXT = 0;
                                    END;
                                END;
                        end;
                    END
                    ELSE BEGIN
                        ERROR('No Material Request Line to be get');
                    END;
                    CurrPage.UPDATE;
                end;
            }
            action("Get Material Req. Purch Rcpt")
            {
                Caption = 'Get Material Request Purchase Receipt';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    lRecMRLinePage: Record "Material Req. Line";
                    lRecMRLine: Record "Material Req. Line";
                    lRecMRLineCheck: Record "Material Req. Line";
                    lPageSelectMR: Page "Select MR Line";
                    currMRNo: Code[20];
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    // Rec.TestField("Shortcut Dimension 2 Code");
                    gCUMRFunct.refreshOutsMRInvShipBol(Rec."Shortcut Dimension 1 Code", Rec."Unit Group", Rec."MR Usage Category");
                    COMMIT;
                    lRecMRLinePage.RESET;
                    lRecMRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecMRLinePage.SETFILTER("Outstanding Qty Invt. Shpt", '>%1', 0);
                    lRecMRLinePage.SETFILTER(Status, '%1|%2', lRecMRLinePage.Status::Released, lRecMRLinePage.Status::Processed);
                    lRecMRLinePage.SETRANGE(Cancel, FALSE);
                    lRecMRLinePage.SETRANGE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                    lRecMRLinePage.SETRANGE("Unit Group", Rec."Unit Group");
                    lRecMRLinePage.SETRANGE("MR Usage Category", Rec."MR Usage Category");
                    lRecMRLinePage.SETRANGE("Outstanding Qty Invt. Shpt Bol", TRUE);
                    IF lRecMRLinePage.FIND('-') THEN BEGIN
                        CLEAR(lPageSelectMR);
                        lPageSelectMR.SetTableView(lRecMRLinePage);
                        lPageSelectMR.LookupMode(true);
                        CASE lPageSelectMR.RUNMODAL() OF
                            ACTION::LookupOK:
                                BEGIN
                                    CurrPage.UPDATE();
                                    lRecMRLine.RESET;
                                    lRecMRLineCheck.RESET;
                                    lPageSelectMR.SetSelectionFilter(lRecMRLine);
                                    lPageSelectMR.SetSelectionFilter(lRecMRLineCheck);
                                    lRecMRLineCheck.SetCurrentKey("Material Req. No.");
                                    lRecMRLineCheck.ASCENDING(TRUE);
                                    IF lRecMRLineCheck.FIND('-') THEN BEGIN
                                        REPEAT
                                            IF (currMRNo <> '') AND (currMRNo <> lRecMRLineCheck."Material Req. No.") THEN BEGIN
                                                ERROR('cannot select more than 1 Material Request No.');
                                            END;
                                            currMRNo := lRecMRLineCheck."Material Req. No.";
                                        UNTIL lRecMRLineCheck.NEXT = 0;
                                    END;
                                    IF lRecMRLine.FIND('-') THEN BEGIN
                                        REPEAT
                                            gCUMRFunct.checkMultipleMR_InvShip(lRecMRLine, Rec."No.");
                                            gCUMRFunct.createInvDocLine_PurchRcpt(lRecMRLine, Rec."No.");
                                        UNTIL lRecMRLine.NEXT = 0;
                                    END;
                                END;
                        end;
                    END
                    ELSE BEGIN
                        ERROR('No Material Request Line to be get');
                    END;
                    CurrPage.UPDATE;
                end;
            }
        }
    }
    var
        gCUMRFunct: Codeunit "Material Req. Function";
}
