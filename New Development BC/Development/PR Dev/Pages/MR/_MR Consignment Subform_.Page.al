page 80128 "MR Consignment Subform"
{
    PageType = ListPart;
    SourceTable = "MR Consignment Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    RefreshOnActivate = TRUE;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Material Req. No. field.';
                    Editable = false;
                    Visible = false;
                }
                field("Material Req. Type"; Rec."Material Req. Type")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    DecimalPlaces = 0 : 5;
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                    Editable = FALSE;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;
                }
                field(Cancel; Rec.Cancel)
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                    Visible = FALSE; //CR
                }
                field("Reason Cancel"; Rec."Reason Cancel")
                {
                    ApplicationArea = All;
                    Editable = TRUE;
                    Visible = FALSE; //CR
                }
                field("Total Qty On PR"; Rec."Total Qty On PR")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
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
        }
    }
    actions
    {
        area(Processing)
        {
            action("Cancel PR Line")
            {
                ApplicationArea = All;
                Image = Cancel;
                Visible = FALSE; //CR

                trigger OnAction()
                var
                    lRecMRLine: Record "MR Consignment Line";
                    ConfirmTxt: TextConst ENU = 'Are you sure to cancel this Material Request Line?';
                begin
                    IF Rec.Status = Rec.Status::Open THEN ERROR('Status must not open to use this function');
                    Rec.TestField("Line No.");
                    Rec.TestField(Cancel, FALSE);
                    gCUMRFunct.checkMRLinehasPR_Cancel(Rec."Material Req. No.", Rec."Line No.");
                    IF CONFIRM(ConfirmTxt) THEN BEGIN
                        lRecMRLine.RESET;
                        CurrPage.SetSelectionFilter(lRecMRLine);
                        IF lRecMRLine.FIND('-') THEN BEGIN
                            REPEAT
                                lRecMRLine.VALIDATE(Cancel, TRUE);
                                lRecMRLine.MODIFY;
                            UNTIL lRecMRLine.NEXT = 0;
                        END;
                        gCUMRFunct.closedStatus_MR(Rec."Material Req. No.");
                    END;
                    CurrPage.UPDATE;
                end;
            }
            action("Undo Cancel PR Line")
            {
                ApplicationArea = All;
                Image = Undo;
                Visible = FALSE; //CR

                trigger OnAction()
                var
                    lRecMRLine: Record "MR Consignment Line";
                    ConfirmTxt: TextConst ENU = 'Are you sure to undo cancel this Material Request Line?';
                begin
                    IF Rec.Status = Rec.Status::Open THEN ERROR('Status must not open to use this function');
                    Rec.TestField("Line No.");
                    Rec.TestField(Cancel, TRUE);
                    IF CONFIRM(ConfirmTxt) THEN BEGIN
                        lRecMRLine.RESET;
                        CurrPage.SetSelectionFilter(lRecMRLine);
                        IF lRecMRLine.FIND('-') THEN BEGIN
                            REPEAT
                                lRecMRLine.VALIDATE(Cancel, FALSE);
                                lRecMRLine.MODIFY;
                            UNTIL lRecMRLine.NEXT = 0;
                        END;
                        gCUMRFunct.closedStatus_MR(Rec."Material Req. No.");
                    END;
                    CurrPage.UPDATE;
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
        Rec.CalcFields(Status);
        IF Rec.Status = Rec.Status::Open THEN BEGIN
            gBolEditable := TRUE;
        END
        ELSE BEGIN
            gBolEditable := FALSE;
        END;
    end;

    var
        gBolEditable: Boolean;
        gCUMRFunct: Codeunit "MR Consignment Function";
}
