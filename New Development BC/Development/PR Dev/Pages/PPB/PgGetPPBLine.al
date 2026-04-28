
page 60114 GetppbLine
{
    PageType = ListPart;
    Caption = 'Get PPB Line';
    ApplicationArea = All;
    Editable = false;
    SourceTable = PPBLine;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    HideValue = DocumentNoHideValue;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = all;
                }
                field(VendorOrderNo; VendorOrderNo)

                {
                    ApplicationArea = suite;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }


            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DocumentNoHideValue := false;
        DocumentNoOnFormat();
        GetDataFromRcptHeader();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetDataFromRcptHeader();
    end;

    trigger OnQueryClosePage(CloseAction: Action) Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnQueryClosePage(CloseAction, Result, IsHandled);
        if IsHandled then
            exit(Result);

        if CloseAction in [ACTION::OK, ACTION::LookupOK] then
            CreateLines();
    end;

    var
        PurchHeader: Record RFQHEADER;
        PurchRcptHeader: Record PPBHeader;
        TempPurchRcptLine: Record PPBLine temporary;
        GetReceipts: Codeunit GetPpbLine;
        VendorOrderNo: Code[35];
        VendorShptNo: Code[35];
        OrderNo: Code[20];
        ItemReferenceNo: Code[50];

    protected var
        [InDataSet]
        DocumentNoHideValue: Boolean;

    procedure SetPurchHeader(var PurchHeader2: Record RFQHEADER)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetPurchHeader(PurchHeader2, IsHandled, PurchHeader);
        if IsHandled then
            exit;

        PurchHeader.Get(PurchHeader2."No.", PurchHeader2."No.PPB");
        PurchHeader.TestField("No.PPB");
    end;

    protected procedure IsFirstDocLine(): Boolean
    var
        PurchRcptLine: Record PPBLine;
    begin
        TempPurchRcptLine.Reset();
        TempPurchRcptLine.CopyFilters(Rec);
        TempPurchRcptLine.SetRange("Document No.", rec."Document No.");
        if not TempPurchRcptLine.FindFirst() then begin
            PurchRcptLine.CopyFilters(Rec);
            PurchRcptLine.SetRange("Document No.", REC."Document No.");
            if PurchRcptLine.FindFirst() then begin
                TempPurchRcptLine := PurchRcptLine;
                TempPurchRcptLine.Insert();
            end;
        end;
        if rec."Line No." = TempPurchRcptLine."Line No." then
            exit(true);
    end;

    local procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        GetReceipts.SetPurchHeader(PurchHeader);
        GetReceipts.CreateInvLines(Rec);
    end;

    local procedure DocumentNoOnFormat()
    begin
        if not IsFirstDocLine() then
            DocumentNoHideValue := true;
    end;

    local procedure GetDataFromRcptHeader()
    var
        SrcPurchRcptHeader: Record PPBHeader;
    begin
        SrcPurchRcptHeader.Get(Rec."Document No.");
        VendorOrderNo := SrcPurchRcptHeader."No.";

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetPurchHeader(var PurchaseHeader: Record RFQHEADER; var IsHandled: Boolean; var PurchHeader: Record RFQHEADER)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeOnQueryClosePage(CloseAction: Action; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

}