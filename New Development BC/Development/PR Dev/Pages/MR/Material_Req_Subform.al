page 50180 "Material Req. Subform2"
{
    Caption = 'Material Request Subform';
    PageType = ListPart;
    SourceTable = "Material Req. Line";
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    DecimalPlaces = 0 : 5;
                    Caption = 'Quantity';
                    Editable = gBolEditable;
                    ShowMandatory = TRUE;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE();
                    end;
                }

                field("Quantity Delivery"; Rec."Quantity Delivery")
                {
                    ApplicationArea = all;
                    CaptionClass = 'Quantity Delivery';
                    DecimalPlaces = 0 : 5;
                    Editable = greleased;
                    Caption = 'Quantity Delivery';


                }
                field("Unit of Measure"; Rec."Unit of Measure")
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
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Outstanding Qty Invt. Shpt"; Rec."Outstanding Qty Invt. Shpt")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
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
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Total Qty On Purch Rcpt"; Rec."Total Qty On Purch Rcpt")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Qty Invt. Shpt Purch. Rcpt"; Rec."Qty Invt. Shpt Purch. Rcpt")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;

                    trigger OnDrillDown()
                    var
                        lRecInvShipLine: Record "Invt. Shipment Line";
                    begin
                        IF Rec."Qty Invt. Shpt Purch. Rcpt" <> 0 THEN BEGIN
                            lRecInvShipLine.RESET;
                            lRecInvShipLine.SETRANGE(lRecInvShipLine."Material Req. No.", Rec."Material Req. No.");
                            lRecInvShipLine.SETRANGE(lRecInvShipLine."Material Req. Line No.", Rec."Line No.");
                            lRecInvShipLine.SETRANGE("MR Purch. Receipt", TRUE);
                            IF lRecInvShipLine.FIND('-') THEN PAGE.RUNMODAL(PAGE::"Posted Invt. Shipment Lines", lRecInvShipLine);
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                field("Total Qty On Inv. Shpt"; Rec."Total Qty On Inv. Shpt")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Total Qty On Posted Inv. Shpt"; Rec."Total Qty On Posted Inv. Shpt")
                {
                    ApplicationArea = all;
                    Editable = FALSE;
                    DecimalPlaces = 0 : 5;
                    Caption = 'Quantity Delivered';

                    trigger OnDrillDown()
                    var
                        lRecInvShipLine: Record "Invt. Shipment Line";
                    begin
                        Rec.CalcFields("Total Qty On Posted Inv. Shpt");
                        IF Rec."Total Qty On Posted Inv. Shpt" <> 0 THEN BEGIN
                            lRecInvShipLine.RESET;
                            lRecInvShipLine.SETRANGE(lRecInvShipLine."Material Req. No.", Rec."Material Req. No.");
                            lRecInvShipLine.SETRANGE(lRecInvShipLine."Material Req. Line No.", Rec."Line No.");
                            IF lRecInvShipLine.FIND('-') THEN PAGE.RUNMODAL(PAGE::"Posted Invt. Shipment Lines", lRecInvShipLine);
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                field("Total Qty On Item Journal"; Rec."Total Qty On Item Journal")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = FALSE;
                }
                field("Total Qty On ILE"; Rec."Total Qty On ILE")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
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
                    lRecMRLine: Record "Material Req. Line";
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
                    lRecMRLine: Record "Material Req. Line";
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
        gBolEditable := false;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Status);
        IF Rec.Status = Rec.Status::Released THEN BEGIN
            greleased := TRUE;
        END
        ELSE BEGIN
            greleased := FALSE;
            gBolEditable := false;
        END;

        TotalA();
    end;

    procedure TotalA()
    begin
        rec."Quantity Delivery" := 0;
        rec."Quantity Delivery" := rec.Quantity - rec."Total Qty On Posted Inv. Shpt";
    end;


    var
        gBolEditable, greleased : Boolean;
        gCUMRFunct: Codeunit "Material Req. Function";
}
