codeunit 80109 "PR Asset Function"
{
    trigger OnRun()
    begin
    end;
    //Check
    procedure checkPRLinehasPO(PRNo: Code[20]; PRLineNo: Integer; msgErr: Text)
    var
        lRecPRLine: Record "PR Asset Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.CalcFields("Total Qty on PO");
        lRecPRLine.SETRANGE("Purchase Req. No.", PRNo);
        IF PRLineNo <> 0 THEN lRecPRLine.SETRANGE("Line No.", PRLineNo);
        lRecPRLine.SETFILTER("Total Qty on PO", '>%1', 0);
        IF lRecPRLine.FINDFIRST THEN BEGIN
            ERROR('Purchase Request Line %1 already has Purchase Order, cannot %2', lRecPRLine."Line No.", msgErr)
        END;
        lRecPRLine.RESET;
        lRecPRLine.CalcFields("Total Qty on Posted Order");
        lRecPRLine.SETRANGE("Purchase Req. No.", PRNo);
        IF PRLineNo <> 0 THEN lRecPRLine.SETRANGE("Line No.", PRLineNo);
        lRecPRLine.SETFILTER("Total Qty on Posted Order", '>%1', 0);
        IF lRecPRLine.FINDFIRST THEN BEGIN
            ERROR('Purchase Request Line %1 already has Posted Purchase Order, cannot %2', lRecPRLine."Line No.", msgErr)
        END;
    end;

    procedure checkPRLinehasOutstanding(PRNo: Code[20]): Boolean
    var
        lRecPRLine: Record "PR Asset Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", PRNo);
        lRecPRLine.SETFILTER("Outstanding Quantity", '>%1', 0);
        IF lRecPRLine.FINDFIRST THEN BEGIN
            EXIT(TRUE)
        END;
        EXIT(FALSE);
    end;
    //Check
    //UpdateOutsanding
    procedure updOutstandingQtyPR(var ParPRLine: Record "PR Asset Line"; fromRecordID: RecordID; QtytoUpd: Decimal; fromCreatePO: Boolean)
    var
        lRecPRHeader: Record "PR Asset Header";
        lRecPRLine: Record "PR Asset Line";
        lRecPurchLine: Record "Purchase Line";
        lRecPurchInvLine: Record "Purch. Inv. Line";
        lDecTotalPOQty: Decimal;
        lDecOutstandingQty: Decimal;
        fromRecRef: RecordRef;
        StatusInt: Integer;
    begin
        CLEAR(lDecTotalPOQty);
        CLEAR(lDecOutstandingQty);
        CLEAR(fromRecRef);
        CASE fromRecordID.TableNo OF
            database::"Purchase Line":
                BEGIN
                    lRecPurchLine.RESET;
                    lRecPurchLine.SETRANGE(lRecPurchLine."Purchase Req. No.", ParPRLine."Purchase Req. No.");
                    lRecPurchLine.SETRANGE(lRecPurchLine."Purchase Req. Line No.", ParPRLine."Line No.");
                    IF lRecPurchLine.FIND('-') THEN BEGIN
                        lRecPurchLine.CalcSums(Quantity);
                        lDecTotalPOQty += ABS(lRecPurchLine.Quantity);
                    END;
                    lRecPurchLine.RESET;
                    lRecPurchLine.GET(fromRecordID);
                    lDecTotalPOQty := lDecTotalPOQty - lRecPurchLine.Quantity;
                    lRecPurchInvLine.RESET;
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."Purchase Req. No.", ParPRLine."Purchase Req. No.");
                    lRecPurchInvLine.SETRANGE(lRecPurchInvLine."Purchase Req. Line No.", ParPRLine."Line No.");
                    IF lRecPurchInvLine.FIND('-') THEN BEGIN
                        lRecPurchInvLine.CalcSums(Quantity);
                        lDecTotalPOQty += ABS(lRecPurchInvLine.Quantity);
                    END;
                END;
        END;
        lDecOutstandingQty := ParPRLine.Quantity - lDecTotalPOQty - QtytoUpd;
        IF lDecOutstandingQty > 0 THEN BEGIN
            ParPRLine."Outstanding Quantity" := lDecOutstandingQty;
        END
        ELSE BEGIN
            ParPRLine."Outstanding Quantity" := 0;
        END;
        ParPRLine."Qty to PO" := ParPRLine."Outstanding Quantity";
        ParPRLine.MODIFY;
        IF FromCreatePO = FALSE THEN closedStatus_PRAsset(ParPRLine."Purchase Req. No.");
    end;

    procedure closedStatus_PRAsset(PRNo: Code[20])
    var
        lRecPRHeader: Record "PR Asset Header";
        lRecPRLine: Record "PR Asset Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRNo);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecPRLine.Quantity > lRecPRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecPRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecPRLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
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
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        IF statusInt <> 0 THEN BEGIN
            lRecPRHeader.RESET;
            lRecPRHeader.SETRANGE(lRecPRHeader."Purchase Req. No.", PRNo);
            IF lRecPRHeader.FINDFIRST THEN BEGIN
                Case StatusInt OF
                    1:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Released);
                    2:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Processed);
                    3:
                        lRecPRHeader.VALIDATE(Status, lRecPRHeader.Status::Closed);
                END;
                lRecPRHeader.MODIFY;
            END;
        END;
    end;

    procedure closedStatus_PRAssetfromCreatePO(PRNo: Code[20]): Integer
    var
        lRecPRHeader: Record "PR Asset Header";
        lRecPRLine: Record "PR Asset Line";
        isOutstanding: Boolean;
        hasProcess: Boolean;
        hasLine: Boolean;
        statusInt: Integer;
    begin
        isOutstanding := FALSE;
        hasLine := FALSE;
        hasProcess := FALSE;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE(lRecPRLine."Purchase Req. No.", PRNo);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                hasLine := TRUE;
                IF lRecPRLine.Quantity > lRecPRLine."Outstanding Quantity" THEN hasProcess := TRUE;
                IF lRecPRLine."Outstanding Quantity" > 0 THEN isOutstanding := TRUE;
            UNTIL (lRecPRLine.NEXT = 0);
        END;
        IF hasLine THEN BEGIN
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
        END
        ELSE BEGIN
            statusInt := 3;
        END;
        exit(statusInt);
    end;
    //UpdateOutsanding
    //Create PO
    procedure createPOHeader_PRAsset(var ParPRHeader: Record "PR Asset Header")
    var
        PurchHeaderIns: Record "Purchase Header";
        PurchLineView: Record "Purchase Line";
        lRecPRLine: Record "PR Asset Line";
        lRecVendor: Record Vendor;
        lRecPurchSetup: Record "Purchases & Payables Setup";
        lRecNoSeries: Record "No. Series";
        CurrVendorNo: Code[20];
        StatusInt: Integer;
        currPRNo: Code[20];
        currPRNoAdditionalLine: Code[20];
        OutstandingQty: Decimal;
        BatchNo: Integer;
    begin
        CLEAR(StatusInt);
        CLEAR(currPRNoAdditionalLine);
        CLEAR(CurrVendorNo);
        ParPRHeader.TestField("Vendor No.");
        lrecPurchSetup.GET();
        gRecMIISetup.GET();
        lRecNoSeries.RESET;
        lRecNoSeries.GET(ParPRHeader."No. Series");
        lRecNoSeries.TESTFIELD("Invt. Shipment Nos.");
        BatchNo := ParPRHeader."Batch No. [PR]" + 1;
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", ParPRHeader."Purchase Req. No.");
        lRecPRLine.SETFILTER("Qty to PO", '>%1', 0);
        lRecPRLine.SetCurrentKey("Line No.");
        lRecPRLine.Ascending(TRUE);
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                IF CurrVendorNo <> ParPRHeader."Vendor No." THEN BEGIN
                    lRecVendor.RESET;
                    lRecVendor.GET(ParPRHeader."Vendor No.");
                    lRecVendor.TestField(lRecVendor.Blocked, lRecVendor.Blocked::" ");
                    PurchHeaderIns.INIT;
                    PurchHeaderIns."Document Type" := PurchHeaderIns."Document Type"::Order;
                    PurchHeaderIns.VALIDATE(PurchHeaderIns."No. Series", gRecMIISetup."Purchase Order Nos.");
                    //PurchHeaderIns."No." := gCUNoSeriesMgt.GetNextNo(lRecNoSeries."Purchase Order Nos.", WORKDATE, TRUE);
                    PurchHeaderIns."No." := NoSeries.GetNextNo(lRecNoSeries."Purchase Order Nos.", WorkDate(), true);
                    PurchHeaderIns.vALIDATE("No. Series", lRecNoSeries."Purchase Order Nos.");
                    PurchHeaderIns.VALIDATE("Buy-from Vendor No.", lRecPRLine."Vendor No.");
                    PurchHeaderIns.INSERT(TRUE);
                    PurchHeaderIns.VALIDATE("Document Date", ParPRHeader."Request Date");
                    PurchHeaderIns.VALIDATE("Location Code", ParPRHeader."Location Code");
                    // PurchHeaderIns.VALIDATE("Currency Code", ParRFQHeader."Currency Code");
                    PurchHeaderIns.VALIDATE("Payment Terms Code", ParPRHeader."Payment Terms Code");
                    // PurchHeaderIns.VALIDATE("Ship-to Code", lRecRFQVendor."Ship-to Code");
                    PurchHeaderIns."Purchase Req. No." := lRecPRLine."Purchase Req. No.";
                    PurchHeaderIns.MODIFY(TRUE);
                    createPOLine_PRAsset(lRecPRLine, PurchHeaderIns."No.", BatchNo);
                END
                ELSE BEGIN
                    createPOLine_PRAsset(lRecPRLine, PurchHeaderIns."No.", BatchNo);
                END;
                CurrVendorNo := ParPRHeader."Vendor No.";
            UNTIL lRecPRLine.NEXT = 0;
        END
        ELSE BEGIN
            ERROR('No PR Asset Line to be found for create PO');
        END;
        ParPRHeader."Batch No. [PR]" := BatchNo;
        StatusInt := closedStatus_PRAssetfromCreatePO(ParPRHeader."Purchase Req. No.");
        IF statusInt <> 0 THEN BEGIN
            Case StatusInt OF
                1:
                    ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Released);
                2:
                    ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Processed);
                3:
                    ParPRHeader.VALIDATE(Status, ParPRHeader.Status::Closed);
            END;
        END;
        ParPRHeader.MODIFY;
        COMMIT;
        PurchLineView.RESET;
        PurchLineView.SETRANGE(PurchLineView."Purchase Req. No.", ParPRHeader."Purchase Req. No.");
        PurchLineView.SETRANGE(PurchLineView."RFQ No.", '');
        PurchLineView.SETRANGE(PurchLineView."Document Type", PurchLineView."Document Type"::Order);
        PurchLineView.SETRANGE(PurchLineView."Batch No. [PR]", BatchNo);
        IF PurchLineView.FIND('-') THEN Page.RUN(Page::"Purchase Lines", PurchLineView);
    end;

    procedure createPOLine_PRAsset(ParPRLine: Record "PR Asset Line"; PONo: Code[20]; BatchNo: Integer)
    var
        PurchLineIns: Record "Purchase Line";
    begin
        PurchLineIns.INIT;
        PurchLineIns."Document Type" := PurchLineIns."Document Type"::Order;
        PurchLineIns."Document No." := PONo;
        PurchLineIns."Line No." := getLastLineNoPO(PONo);
        PurchLineIns.INSERT(TRUE);
        case ParPRLine."Type" OF
            ParPRLine."Type"::" ":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::" ");
                end;
            ParPRLine."Type"::"G/L Account":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::"G/L Account");
                    PurchLineIns.Validate("No.", ParPRLine."No.");
                    PurchLineIns.VALIDATE("Gen. Prod. Posting Group", gRecMIISetup."Default Gen. Prod PO");

                end;
            ParPRLine."Type"::Item:
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::Item);
                    PurchLineIns.Validate("No.", ParPRLine."No.");

                end;
            ParPRLine."Type"::"Fixed Asset":
                begin
                    PurchLineIns.Validate(Type, PurchLineIns.Type::"G/L Account");
                    gRecMIISetup.GET();
                    PurchLineIns.Validate("No.", gRecMIISetup."No. G/L FA");
                    PurchLineIns.VALIDATE("Gen. Prod. Posting Group", gRecMIISetup."Default Gen. Prod PO");

                end;
        end;
        PurchLineIns.Validate("PR Line Type", ParPRLine."Type");
        PurchLineIns.Validate(Quantity, ParPRLine."Qty to PO");
        PurchLineIns.VALIDATE("Direct Unit Cost", ParPRLine."Direct Unit Cost");
        PurchLineIns.VALIDATE("Line Discount %", ParPRLine."Discount %");
        PurchLineIns.Description := ParPRLine.Description;
        PurchLineIns.VALIDATE("Unit of Measure", ParPRLine."Unit of Measure");
        PurchLineIns.Validate("Part No.", ParPRLine."Part No.");
        PurchLineIns.Validate("Purchase Req. No.", ParPRLine."Purchase Req. No.");
        PurchLineIns.Validate("Purchase Req. Line No.", ParPRLine."Line No.");
        PurchLineIns.VALIDATE("VAT Prod. Posting Group", ParPRLine."VAT Prod. Posting Group");
        PurchLineIns.VALIDATE("VAT Bus. Posting Group", ParPRLine."VAT Bus. Posting Group");
        PurchLineIns.VALIDATE("Shortcut Dimension 3 Code", ParPRLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(3, ParPRLine."Shortcut Dimension 3 Code");
        PurchLineIns.ValidateShortcutDimCode(4, ParPRLine."Shortcut Dimension 4 Code");
        PurchLineIns.ValidateShortcutDimCode(5, ParPRLine."Shortcut Dimension 5 Code");
        PurchLineIns.ValidateShortcutDimCode(6, ParPRLine."Shortcut Dimension 6 Code");
        PurchLineIns.ValidateShortcutDimCode(7, ParPRLine."Shortcut Dimension 7 Code");
        PurchLineIns.ValidateShortcutDimCode(8, ParPRLine."Shortcut Dimension 8 Code");
        PurchLineIns.VALIDATE("Unit Group", ParPRLine."Unit Group");
        PurchLineIns.VALIDATE("MR Usage Category", ParPRLine."MR Usage Category");
        PurchLineIns."Batch No. [PR]" := BatchNo;
        PurchLineIns."PR Type" := PurchLineIns."PR Type"::Asset;
        PurchLineIns.MODIFY(TRUE);
        updOutstandingQtyPR(ParPRLine, PurchLineIns.RecordID, ParPRLine."Qty to PO", TRUE)
    end;
    //Create PO
    procedure changeColorStyleUrgent(var parPRHeader: Record "PR Asset Header"): Text[50]
    begin
        CASE parPRHeader."Urgent Status" OF
            parPRHeader."Urgent Status"::Low:
                Exit('Favorable');
            parPRHeader."Urgent Status"::Medium:
                Exit('Ambiguous');
            parPRHeader."Urgent Status"::High:
                Exit('Unfavorable');
        END;
        Exit('Standard')
    end;

    local procedure getLastLineNoPO(PONo: Code[20]): Integer
    var
        lRecPurchLine: Record "Purchase Line";
    begin
        lRecPurchLine.RESET;
        lRecPurchLine.SETRANGE("Document No.", PONo);
        IF lRecPurchLine.FINDLAST THEN
            EXIT(lRecPurchLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;

    var
        gRecMIISetup: Record "MII Setup";
        //gCUNoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        gCUMRFunct: Codeunit "Material Req. Function";
}
