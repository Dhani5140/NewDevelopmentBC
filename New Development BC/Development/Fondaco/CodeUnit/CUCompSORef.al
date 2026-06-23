codeunit 70003 CUCompSORef
{
    Permissions = TableData "Sales Line" = rimd,
                  TableData TblCompSOReference = rimd,
                    TableData "Sales Header" = rimd,
                    TableData "Purchase Line" = rimd,
                    TableData "Purchase Header" = rimd;


    TableNo = TblCompSOReference;

    trigger OnRun()
    begin

    end;

    procedure UpdateSORef(NoSo: Text; LineNoSO: Integer; UserName: Text)
    var
        tblref: Record TblCompSOLineRef;
    begin
        //tblref.Get(1);
        // tblref.Delete();
        // tblref.Urutan := 1;
        // tblref."Document No." := NoSo;
        // tblref."Line No." := LineNoSO;
        // tblref.Insert()

        if tblref.get(1, UserName) then begin
            tblref."Document No." := NoSo;
            tblref."Line No." := LineNoSO;
            tblref.Modify()
        end else begin
            insertpertama(NoSo, LineNoSO, UserName)
        end;
    end;


    procedure insertpertama(NoSo: Text; LineNoSO: Integer; UserName: Text)
    var
        tblref: Record TblCompSOLineRef;
    begin
        tblref.Urutan := 1;
        tblref."Document No." := NoSo;
        tblref."Line No." := LineNoSO;
        tblref."User Name" := UserName;
        tblref.Insert()
    end;


    // // Turn off Invoice Posting Option in PO// START >*******************************************************************
    // [EventSubscriber(ObjectType::Codeunit, 91, 'OnBeforeConfirmPost', '', false, false)]
    // local procedure MyPurchaseConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)

    // var
    //     Question: Text;
    //     Answer: Boolean;
    //     CustomerNo: Integer;
    //     Text004: Label 'Are you sure to post this Receive ?';
    //     Text005: Label 'You selected %1.';
    //     PurchDocType: Enum "Purchase Document Type";
    // begin

    //     if PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::Order] then begin
    //         Question := Text004;
    //         Answer := Dialog.CONFIRM(Question, FALSE);

    //         if Answer = true then begin
    //             DefaultOption := 1;
    //             HideDialog := true;
    //             IsHandled := false;
    //             //MyCustomConfirmPost(PurchaseHeader, DefaultOption);
    //         end else begin
    //             IsHandled := true;
    //             exit;
    //         end;
    //     end else begin
    //         exit;
    //     end;
    // end;




    // // Turn off Invoice Posting Option in PO// END <*******************************************************************


    // // Turn off Invoice Posting Option in SO// START >*******************************************************************
    // [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    // local procedure MyConfirmSalesPost(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer; var PostAndSend: Boolean)
    // var
    //     Question: Text;
    //     Answer: Boolean;
    //     CustomerNo: Integer;
    //     Text004: Label 'Are you sure to post this Sales Shipment ?';
    //     Text005: Label 'You selected %1.';
    // begin

    //     // if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order] then begin
    //     //     Question := Text004;
    //     //     Answer := Dialog.CONFIRM(Question, FALSE);

    //     //     if Answer = true then begin

    //     HideDialog := true;
    //     //DefaultOption := 1;
    //     //IsHandled := false;
    //     MyCustomConfirmSalesPost(SalesHeader, DefaultOption);
    //     //         end else begin
    //     //             IsHandled := true;
    //     //             exit;
    //     //         end;
    //     //     end else begin
    //     //         exit;
    //     //     end;
    // end;

    // local procedure MyCustomConfirmSalesPost(var SalesHeader: Record "Sales Header"; DefaultOption: Integer): Boolean

    // var
    //     //ShipInvoiceQst: Label '&Ship,&Invoice,Ship &and Invoice';
    //     ShipInvoiceQst: Label '&Ship';
    //     PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
    //     //ReceiveInvoiceQst: Label '&Receive,&Invoice,Receive &and Invoice';
    //     ReceiveInvoiceQst: Label '&Receive';

    //     ConfirmManagement: Codeunit "Confirm Management";
    //     Selection: Integer;
    // begin

    //     DefaultOption := 0;
    //     with SalesHeader do begin
    //         case "Document Type" of
    //             "Document Type"::Order:
    //                 begin
    //                     Selection := StrMenu(ShipInvoiceQst, DefaultOption);
    //                     Ship := Selection in [1, 1];
    //                     Invoice := Selection in [2, 3];
    //                     if Selection = 0 then
    //                         exit(false);
    //                 end;
    //             "Document Type"::"Return Order":
    //                 begin
    //                     Selection := StrMenu(ReceiveInvoiceQst, DefaultOption);
    //                     if Selection = 0 then
    //                         exit(false);
    //                     Receive := Selection in [1, 3];
    //                     Invoice := Selection in [2, 3];
    //                 end
    //             else
    //                 if not ConfirmManagement.GetResponseOrDefault(
    //                      StrSubstNo(PostConfirmQst, LowerCase(Format("Document Type"))), true)
    //                 then
    //                     exit(false);
    //         end;

    //     end;
    //     exit(true);
    // end;
    // Turn off Invoice Posting Option in SO// END <*******************************************************************
}