codeunit 60101 GetPpbLine
{
    TableNo = Rfqline;

    trigger OnRun()
    begin
        CheckHeader(Rec);

        PPBLi.SetCurrentKey("Document No.");
        PPBLi.SetRange("Document No.", rfqhead."No.");
        PPBLi.SetRange("Document No.", rfqhead."No.PPB");

        OnAfterPurchRcptLineSetFilters(PPBLi, rfqhead);

        GETPPB.SetTableView(PPBLi);
        GETPPB.LookupMode := true;
        GETPPB.SetPurchHeader(rfqhead);
        GETPPB.RunModal();
    end;

    var
        Text000: Label 'The %1 on the %2 %3 and the %4 %5 must be the same.';
        PPBHead: Record PPBHeader;
        PPBLi: Record PPBLine;

        rfqhead: Record RFQHEADER;
        rfqline: Record Rfqline;

        GETPPB: page GetppbLine;
        UOMMgt: Codeunit "Unit of Measure Management";

    procedure CreateInvLines(var ppbli2: Record PPBLine)
    var
        TransferLine: Boolean;
        PrepmtAmtToDeductRounding: Decimal;
        IsHandled: Boolean;
        ShowDifferentPayToVendMsg: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateInvLines(ppbli2, IsHandled);
        if IsHandled then
            exit;

        ppbli2.SetFilter("No.", rfqhead."No.PPB");
        OnCreateInvLinesOnBeforeFind(ppbli2, rfqhead);
        if ppbli2.Find('-') then begin
            rfqline.LockTable();
            rfqline.SetRange(rfqline."No.", rfqhead."No.");
            rfqline.SetRange(rfqline."PPB Document No.", rfqhead."No.PPB");
            rfqline."No." := rfqhead."No.";
            rfqline."PPB Document No." := rfqhead."No.PPB";



            OnBeforeInsertLines(rfqhead, rfqline);

            repeat
                if rfqhead."No." <> rfqline."No." then begin
                    rfqhead.get(ppbli2."No.");
                    if PPBHead."No." <> rfqhead."No.PPB" then begin
                        Message(
                          Text000,
                          rfqhead.FieldCaption("No.PPB"),
                          rfqhead.TableCaption(), rfqhead."No.",
                          PPBHead.TableCaption(), PPBHead."No.");
                        TransferLine := false;
                    end;

                end;

            until ppbli2.Next() = 0;

        end;
    end;



    local procedure CheckHeader(PPBLine: Record Rfqline)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckHeader(rfqhead, PPBLine, IsHandled);
        if IsHandled then
            exit;

        rfqhead.get(PPBLine."No.", PPBLine."PPB Document No.");
        rfqhead.TestField("No.PPB");

    end;



    procedure SetPurchHeader(var RFQHeader2: Record RFQHEADER)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetPurchHeader(rfqhead, RFQHeader2, IsHandled);
        if IsHandled then
            exit;

        rfqhead.get(RFQHeader2."No.", RFQHeader2."No.PPB");
        rfqhead.TestField("No.PPB");


    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckHeader(var RFQH: Record RFQHEADER; PurchaseLine: Record Rfqline; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetPurchHeader(var PurchHeader: Record RFQHEADER; PurchHeader2: Record RFQHEADER; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchRcptLineSetFilters(var PPBLin: Record PPBLine; RFQHead: Record RFQHEADER)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateInvLines(var ppbline: Record PPBLine; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateInvLinesOnBeforeFind(var ppbline: Record PPBLine; var rfqheadd: Record RFQHEADER)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertLines(var rfqhead: Record RFQHEADER; var rfqline: Record Rfqline)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertInvoiceLineFromReceiptLine(var ppbli: Record PPBLine; var rfqli: Record Rfqline; ppbli2: Record PPBLine; TransferLine: Boolean)
    begin
    end;
}