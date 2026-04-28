page 80120 "PR Asset FA List"
{
    Caption = 'Vendor Bid FA Mgt';
    PageType = List;
    SourceTable = "PR Asset FA List";

    // InsertAllowed = FALSE;
    // UsageCategory = Documents;    
    layout
    {
        area(content)
        {
            field(gPRNo; gPRNo)
            {
                Caption = 'PR No';
                ApplicationArea = All;
                Editable = FALSE;
            }
            field(gPRLineNo; gPRLineNo)
            {
                Caption = 'PR Line No';
                ApplicationArea = All;
                Editable = FALSE;
            }
            field(gQtyPO; gQtyPO)
            {
                Caption = 'Quantity PO';
                ApplicationArea = All;
                Editable = FALSE;
            }
            field(gAmountPO; gAmountPO)
            {
                Caption = 'Line Amount PO';
                ApplicationArea = All;
                Editable = FALSE;
            }
            repeater(General)
            {
                field(gPONo; gPONo)
                {
                    Caption = 'PO No.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field(gPOLineNo; gPOLineNo)
                {
                    Caption = 'PO Line No.';
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
                field("FA No."; Rec."FA No.")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                }
                field("FA Description"; Rec."FA Description")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;
                    // Editable = FALSE;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                            CLEAR(gDecLineAmount);
                            IF Rec.Quantity + getTotalInput(Rec.FieldNo(Quantity)) > gQtyPO THEN ERROR('Cannot input more that %1', (gQtyPO - getTotalInput(Rec.FieldNo(Quantity))));
                            gDecLineAmount := Rec.Quantity * Rec."Unit Price";
                            IF gDecLineAmount + getTotalInput(Rec.FieldNo("Line Amount")) > gAmountPO THEN ERROR('Cannot input more that %1', (gAmountPO - getTotalInput(Rec.FieldNo("Line Amount"))));
                        END;
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = gBolEditable;

                    trigger OnValidate()
                    begin
                        IF xRec."Unit Price" <> Rec."Unit Price" THEN BEGIN
                            CLEAR(gDecLineAmount);
                            gDecLineAmount := Rec.Quantity * Rec."Unit Price";
                            IF gDecLineAmount + getTotalInput(Rec.FieldNo("Line Amount")) > gAmountPO THEN ERROR('Cannot input more that %1', (gAmountPO - getTotalInput(Rec.FieldNo("Line Amount"))));
                        END;
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = FALSE;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add New Line")
            {
                ApplicationArea = All;
                Image = NewItem;
                Promoted = True;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lRec: Record "PR Asset FA List";
                    lRecIns: Record "PR Asset FA List";
                    CountVendor: Integer;
                begin
                    checkEmptyLine();
                    lRec.RESET;
                    lRec.SETRANGE("PO No.", gPONo);
                    lRec.SETRANGE("PO Line No.", gPOLineNo);
                    lRec.SETRANGE("Purchase Req. No.", gPRNo);
                    lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
                    IF lRec.FIND('-') THEN BEGIN
                        lRec.CalcSums(Quantity);
                        IF lRec.Quantity < gQtyPO THEN BEGIN
                            lRecIns.INIT;
                            lRecIns."Entry No." := 0;
                            lRecIns."PO No." := gPONo;
                            lRecIns."PO Line No." := gPOLineNo;
                            lRecIns."Purchase Req. No." := gPRNo;
                            lRecIns."Purchase Req. Line No." := gPRLineNo;
                            lRecIns.INSERT(TRUE);
                        END
                        ELSE BEGIN
                            ERROR('Total Quantity already %1, cannot add more line', gQtyPO);
                        END;
                    END;
                    CurrPage.UPDATE;
                end;
            }
        }
    }
    procedure setDocNo(var ParPONo: Code[20]; var ParPOLineNo: Integer; var ParPRNo: Code[20]; var ParPRLineNo: Integer; var ParQtyPO: Decimal; var ParAmountPO: Decimal)
    begin
        gPONo := ParPONo;
        gPOLineNo := ParPOLineNo;
        gPRNo := ParPRNo;
        gPRLineNo := ParPRLineNo;
        gQtyPO := parQtyPO;
        gAmountPO := parAmountPO;
    end;

    trigger OnOpenPage()
    begin
        gBolEditable := TRUE;
        Rec.RESET;
        Rec.SETRANGE("PO No.", gPONo);
        Rec.SETRANGE("PO Line No.", gPOLineNo);
        Rec.SETRANGE("Purchase Req. No.", gPRNo);
        Rec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        checkEmptyLine();
        checkCountLine();
        Rec."Entry No." := 0;
        Rec."PO No." := gPONo;
        Rec."PO Line No." := gPOLineNo;
        Rec."Purchase Req. No." := gPRNo;
        Rec."Purchase Req. Line No." := gPRLineNo;
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

    procedure checkEmptyLine()
    var
        lRec: Record "PR Asset FA List";
    begin
        lRec.RESET;
        lRec.SETRANGE("PO No.", gPONo);
        lRec.SETRANGE("PO Line No.", gPOLineNo);
        lRec.SETRANGE("Purchase Req. No.", gPRNo);
        lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
        lRec.SETRANGE("FA No.", '');
        IF lRec.FINDFIRST THEN BEGIN
            ERROR('FA No. in line %1 is still empty, please use that line first', lRec."Line No.");
        END;
        lRec.RESET;
        lRec.SETRANGE("PO No.", gPONo);
        lRec.SETRANGE("PO Line No.", gPOLineNo);
        lRec.SETRANGE("Purchase Req. No.", gPRNo);
        lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
        lRec.SETRANGE("Quantity", 0);
        IF lRec.FINDFIRST THEN BEGIN
            ERROR('Quantity in line %1 is still empty, please use that line first', lRec."Line No.");
        END;
    end;

    procedure checkCountLine()
    var
        lRec: Record "PR Asset FA List";
    begin
        lRec.RESET;
        lRec.SETRANGE("PO No.", gPONo);
        lRec.SETRANGE("PO Line No.", gPOLineNo);
        lRec.SETRANGE("Purchase Req. No.", gPRNo);
        lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
        IF lRec.FIND('-') THEN BEGIN
            lRec.CalcSums(Quantity);
            IF lRec.Quantity > gQtyPO THEN ERROR('Total Quantity already %1, cannot add more line', gQtyPO);
        END;
    end;

    procedure getTotalInput(FieldRef: Integer): Decimal
    var
        lRec: Record "PR Asset FA List";
    begin
        case FieldRef of
            Rec.FieldNo("Quantity"):
                BEGIN
                    lRec.RESET;
                    lRec.SETRANGE("PO No.", gPONo);
                    lRec.SETRANGE("PO Line No.", gPOLineNo);
                    lRec.SETRANGE("Purchase Req. No.", gPRNo);
                    lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
                    lRec.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
                    IF lRec.FIND('-') THEN BEGIN
                        lRec.CalcSums(lRec.Quantity);
                        EXIT(lRec.Quantity);
                    END;
                END;
            Rec.FieldNo(Rec."Line Amount"):
                BEGIN
                    lRec.RESET;
                    lRec.SETRANGE("PO No.", gPONo);
                    lRec.SETRANGE("PO Line No.", gPOLineNo);
                    lRec.SETRANGE("Purchase Req. No.", gPRNo);
                    lRec.SETRANGE("Purchase Req. Line No.", gPRLineNo);
                    lRec.SETFILTER("Entry No.", '<>%1', Rec."Entry No.");
                    IF lRec.FIND('-') THEN BEGIN
                        lRec.CalcSums(lRec."Line Amount");
                        EXIT(lRec."Line Amount");
                    END;
                END;
        END;
    end;

    var
        gPONo, gPRNo : Code[20];
        gPOLineNo, gPRLineNo : Integer;
        gQtyPO, gAmountPO, gDecLineAmount : Decimal;
        gBolEditable: Boolean;
}
