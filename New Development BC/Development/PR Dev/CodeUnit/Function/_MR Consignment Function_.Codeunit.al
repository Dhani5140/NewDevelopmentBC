codeunit 80112 "MR Consignment Function"
{
    trigger OnRun()
    begin
    end;
    //Check
    procedure checkMandatoryFields(MRHeader: Record "MR Consignment Header")
    var
        lRecMRLine: Record "MR Consignment Line";
    begin
        MRHeader.Testfield("Location Code");
        MRHeader.TestField("Shortcut Dimension 1 Code");
        MRHeader.TestField("Shortcut Dimension 3 Code");
        MRHeader.TestField("Shortcut Dimension 5 Code");
        MRHeader.TestField("MR Usage Category");
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", MRHeader."Material Req. No.");
        lRecMRLine.SETRANGE(lRecMRLine.Quantity, 0);
        IF lRecMRLine.FINDFIRST THEN ERROR('Qty in Line %1 is still 0, cannot continue', lRecMRLine."Line No.");
    end;

    procedure checkMRLinehasPR(MRNo: Code[20]; msgErr: Text)
    var
        lRecMRLine: Record "MR Consignment Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty on PR");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Total Qty on PR", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has PR, cannot %2', lRecMRLine."Line No.", msgErr)
        END;
    end;

    procedure checkMRLinehasPR_Cancel(MRNo: Code[20]; LineNo: Integer)
    var
        lRecMRLine: Record "MR Consignment Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.CalcFields("Total Qty on PR");
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETRANGE("Line No.", LineNo);
        lRecMRLine.SETFILTER("Total Qty on PR", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            ERROR('Material Request Line %1 already has PR, cannot cancel', lRecMRLine."Line No.")
        END;
    end;

    procedure checkMRLinehasOutstanding(MRNo: Code[20]): Boolean
    var
        lRecMRLine: Record "MR Consignment Line";
    begin
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE("Material Req. No.", MRNo);
        lRecMRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        IF lRecMRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;
    //Check
    //UpdateOutstanding
    procedure updOutstandingQtyMR(var ParMRLine: Record "MR Consignment Line"; fromRecordID: RecordID; QtytoUpd: Decimal)
    var
        lRecMRHeader: Record "MR Consignment Header";
        lRecMRLine: Record "MR Consignment Line";
        lRecPRLine: Record "PR Consignment Line";
        lDecTotalPRQty: Decimal;
        lDecOutstandingQty: Decimal;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalPRQty);
        CLEAR(lDecOutstandingQty);
        CASE fromRecordID.TableNo OF
            database::"PR Consignment Line":
                BEGIN
                    lRecPRLine.RESET;
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. No.", ParMRLine."Material Req. No.");
                    lRecPRLine.SETRANGE(lRecPRLine."Material Req. Line No.", ParMRLine."Line No.");
                    lRecPRLine.SETRANGE(lRecPRLine.Cancel, FALSE);
                    IF lRecPRLine.FIND('-') THEN BEGIN
                        lRecPRLine.CalcSums(Quantity);
                        lDecTotalPRQty += ABS(lRecPRLine.Quantity);
                    END;
                    lRecPRLine.RESET;
                    lRecPRLine.GET(fromRecordID);
                    lDecTotalPRQty := lDecTotalPRQty - lRecPRLine.Quantity;
                END;
        END;
        lDecTotalPRQty := ABS(lDecTotalPRQty);
        lDecOutstandingQty := ParMRLine.Quantity - lDecTotalPRQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParMRLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParMRLine."Outstanding Quantity" := 0;
        END;
        ParMRLine.MODIFY;
        closedStatus_MR(ParMRLine."Material Req. No.");
        // END;
    end;

    procedure closedStatus_MR(MRNo: Code[20])
    var
        lRecMRHeader: Record "MR Consignment Header";
        lRecMRLine: Record "MR Consignment Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        allCancel: Boolean;
        statusInt: integer;
    begin
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        allCancel := TRUE;
        statusInt := 0;
        lRecMRLine.RESET;
        lRecMRLine.SETRANGE(lRecMRLine."Material Req. No.", MRNo);
        IF lRecMRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecMRLine.Cancel = FALSE THEN BEGIN
                    allCancel := FALSE;
                    IF lRecMRLine.Quantity > lRecMRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                    IF lRecMRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
                END;
            UNTIL (lRecMRLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
            IF allCancel THEN BEGIN
                statusInt := 3;
            END
            ELSE BEGIN
                IF hasProcess THEN BEGIN
                    IF isOutstanding THEN BEGIN
                        statusInt := 2;
                    END
                    ELSE BEGIN
                        statusInt := 3;
                    END;
                END
                ELSE BEGIN
                    statusInt := 1;
                END;
            END;
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        IF statusInt <> 0 THEN BEGIN
            lRecMRHeader.RESET;
            lRecMRHeader.SETRANGE(lRecMRHeader."Material Req. No.", MRNo);
            IF lRecMRHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::Released);
                    2:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::Processed);
                    3:
                        lRecMRHeader.VALIDATE(Status, lRecMRHeader.Status::Closed);
                END;
                lRecMRHeader.MODIFY;
            END;
        END;
    end;
    //UpdateOutstanding
    var
        myInt: Integer;
}
