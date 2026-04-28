codeunit 70004 CUInsertSalesLine
{
    Permissions = TableData "Sales Line" = rimd,
                  TableData "Item" = rimd;
    TableNo = "Sales Line";


    trigger OnRun()
    var

        SODocNo: Text;
    //SOLineNo: Integer;
    begin
        SalesOrderLine := Rec;
        // SODocNo := SalesOrderLine."Document No.";
        //SOLineNo := SalesOrderLine."Line No.";
        //SOInsertComplimentary(Rec, QtyCompliment, ComplimentItemNo, ComplimentLineNo);
    end;


    procedure SOInsertComplimentary(SalesOrderLine: Record "Sales Line"; QtyCompliment: Decimal; ComplimentItemNo: Code[20]; ComplimentLineNo: Integer; CompItemUom: Text)
    var
        SOLine: Record "Sales Line";
        DocEnum: Enum "Sales Document Type";
        SalesLineTypeEnum: Enum "Sales Line Type";
        InsertedMsg: Label 'Complimentary item added';
        ItemMaster: Record Item;
    //QtyMain: Decimal;
    begin
        // SOLine.CheckItemAvailable();;

        SOLine."Document No." := SalesOrderLine."Document No.";
        SOLine."Document Type" := DocEnum::Order;
        SOLine."Line No." := ComplimentLineNo;
        SOLine."Sell-to Customer No." := SalesOrderLine."Sell-to Customer No.";
        SOLine.Type := SalesLineTypeEnum::Item;
        SOLine."No." := ComplimentItemNo;
        SOLine.Quantity := QtyCompliment;
        SOLine."Unit of Measure Code" := CompItemUom;
        SOLine.Description := 'Complimentary (Promo) Item';
        SOLine."Unit Price" := 0;
        SOLine.Insert();
        Dialog.Message(InsertedMsg);
    end;

    procedure SOInsertComplimentaryNew(MainItemNo: Code[20]; ComplimentItemNo: Code[20]; QtyMain: Decimal; QtySupp: Decimal; CompMethod: Option)
    var
        SOLine: Record "Sales Line";
        DocEnum: Enum "Sales Document Type";
        SalesLineTypeEnum: Enum "Sales Line Type";
        InsertedMsg: Label 'Complimentary item added';
        TblSoRef: Record TblCompSOLineRef;
        SORefNo: Text;
        SOLineNo: Integer;
        SOLineInsert: Record "Sales Line";
        CustomerNo: Text;
        QtyOrdered: Decimal;
        QtyCummulative: Decimal;
        ItemMaster: Record Item;
        CompItemUOM: Text;
        GenProdPostingGroup: Text;
        InvPostingGroup: Text;
        UnitCost: Decimal;
        TaxGroupCode: Text;
        VATProdPostingGroup: Text;

    //QtyMain: Decimal;
    begin

        if TblSoRef.get(1, UserId) then begin
            SORefNo := TblSoRef."Document No.";
            SOLineNo := TblSoRef."Line No.";
        end;

        if ItemMaster.Get(ComplimentItemNo) then begin
            CompItemUOM := ItemMaster."Base Unit of Measure";
            GenProdPostingGroup := ItemMaster."Gen. Prod. Posting Group";
            InvPostingGroup := ItemMaster."Inventory Posting Group";
            UnitCost := ItemMaster."Unit Cost";
            TaxGroupCode := ItemMaster."Tax Group Code";
            VATProdPostingGroup := ItemMaster."VAT Prod. Posting Group";
        end;

        SOLineInsert.SetRange("Document No.", SORefNo);
        SOLineInsert.SetRange("Line No.", SOLineNo);
        SOLineInsert.SetRange("Document Type", 1);

        If SOLineInsert.FindSet then begin
            CustomerNo := SOLineInsert."Sell-to Customer No.";
            QtyOrdered := SOLineInsert.Quantity;
        end;

        if QtyOrdered < QtyMain then begin
            Message('Cannot continue, Ordered QTY is lower than minimum Qty for this Complimentary / Promo');
            exit
        end;

        if CompMethod = 1 then begin
            QtyCummulative := (QtyOrdered / QtyMain) Div 1;
            QtySupp := QtySupp * QtyCummulative;
        end;

        SOLine."Document No." := SORefNo;
        SOLine."Document Type" := DocEnum::Order;
        SOLine."Line No." := SOLineNo + 10000;
        SOLine."Sell-to Customer No." := CustomerNo;
        SOLine.Type := SalesLineTypeEnum::Item;
        SOLine."No." := ComplimentItemNo;
        SOLine."Unit of Measure Code" := CompItemUOM;
        SOLine.Description := 'Complimentary / Promo Item';
        SOLine."Unit Price" := 0;
        SOLine."Amount Including VAT" := 0;
        SOLine.Amount := 0;
        SOLine."Bill-to Customer No." := CustomerNo;
        SOLine."Gen. Prod. Posting Group" := GenProdPostingGroup;
        SOLine."Posting Group" := InvPostingGroup;
        SOLine."Unit Cost (LCY)" := UnitCost;
        SOLine."Tax Group Code" := TaxGroupCode;
        SOLine."Gen. Bus. Posting Group" := 'DOMESTIC';
        SOLine."VAT Prod. Posting Group" := VATProdPostingGroup;
        SOLine.Quantity := QtySupp;
        SOLine."Qty. to Ship" := QtySupp;
        SOLine."Outstanding Quantity" := QtySupp;
        SOLine."Qty. to Invoice" := QtySupp;
        SOLine."Outstanding Qty. (Base)" := QtySupp;
        SOLine."Quantity (Base)" := QtySupp;
        SOLine."Qty. to Ship (Base)" := QtySupp;
        SOLine."Qty. to Invoice (Base)" := QtySupp;
        SOLine.Insert();
        Dialog.Message(InsertedMsg);
    end;

    procedure GetFromCompPopUp(MainItem: Text; CompItem: text)//;MainQty:Decimal; CompQty: Decimal;)
    var
        SOLineCurrRec: Record "Sales Line";
        SONumber: Text;

    begin
        //SOLineCurrRec := Rec;
        //  if SOLineCurrRec.Get then begin
        //PgSOLine.;
        //PgSOLine.InsertCompItem();
        ;
        SONumber := SOLineCurrRec."Document No.";
        Message(MainItem + ',' + CompItem + ',' + SONumber);
        //  end;
    end;

    procedure QtyCompRounding()
    var
        DecimalToRound: Decimal;
        Direction: Text;
        Result: Decimal;
    begin
        DecimalToRound := 7.5;
        Direction := '<';

        //Result := ROUND(DecimalToRound, 0.01, Direction);
        Result := 17 MOD 2;
        MESSAGE(Format(Result, 0, 1), Direction, Result);
    end;

    var
        SalesOrderLine: Record "Sales Line";
        PgSOLine: Page "Sales Order Subform";

        TxtBuild: TextBuilder;




}