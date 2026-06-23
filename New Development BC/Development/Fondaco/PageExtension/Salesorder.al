pageextension 70005 PgExtSODetail extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(ComplimentaryItem)
            {
                Caption = 'Calculate Complimentary Item';
                ToolTip = 'Calculate Complimentary Item ( Bonus / Bundled Items )';
                ApplicationArea = all;
                Image = Process;
                //Promoted = true;
                //PromotedCategory = Category6;
                //PromotedIsBig = true;

                // RunObject = Page PgCompItemPopUp;
                // RunPageLink = CompMainItem = field("No.");
                // RunPageMode = View;

                trigger OnAction()
                var
                    COMPSetupRec: Record TblCompItemSetup;
                    COMPMapping: Record TblCompItemMapping;
                    SOHeader: Record "Sales Header";
                    SONUmber: Text;
                    i: Integer;
                    SODate: Date;
                    CustCodeVar: Text;
                    CompGroupIdCust: Text;
                    CompGroupIdAll: Text;
                    PrevGroupId: Text;
                    CompStartDate: Date;
                    CompEndingDaate: Date;
                    CompSetup: Record TblCompItemSetup;
                    QtyMainItemSO: Decimal;
                    MainItemQtySetup: Decimal;
                    MainItemCodeSetup: Text;
                    SOLineNumBer: Integer;

                begin
                    i := 0;

                    COMPMapping.Reset();
                    SOHeader.Reset();
                    CompSetup.Reset();
                    COMPSetupRec.Reset();
                    CLEAR(CompGroupIdAll);
                    CLEAR(SONUmber);
                    CLEAR(SODate);
                    CLEAR(CustCodeVar);
                    CLEAR(CompGroupIdCust);
                    CLEAR(PrevGroupId);
                    CLEAR(CompStartDate);
                    CLEAR(CompEndingDaate);
                    CLEAR(QtyMainItemSO);
                    CLEAR(MainItemQtySetup);
                    CLEAR(MainItemCodeSetup);
                    CLEAR(ItemCode);
                    CLEAR(SOLineNumBer);

                    ItemCode := Rec."No.";
                    SONUmber := rec."Document No.";
                    SOLineNumBer := rec."Line No.";
                    CustCodeVar := rec."Sell-to Customer No.";
                    QtyMainItemSO := rec.Quantity;

                    //CUUpdateSORef.insertpertama();
                    CUUpdateSORef.UpdateSORef(SONUmber, SOLineNumBer, UserId);

                    SOHeader.SetRange("No.", SONUmber);
                    if SOHeader.FindSet then begin
                        SODate := SOHeader."Order Date";
                    end;

                    COMPMapping.SetRange(CustCode, CustCodeVar);

                    if COMPMapping.FindSet then
                        repeat
                            CompGroupIdCust := COMPMapping.CompGroupId;
                            CompSetup.get(CompGroupIdCust);
                            CompStartDate := CompSetup.CompBeginDate;
                            CompEndingDaate := CompSetup.CompEndingDate;
                            MainItemCodeSetup := CompSetup.CompMainItem;
                            MainItemQtySetup := CompSetup."Main Item Qty";

                            if CompGroupIdCust <> '' then begin
                                if SODate >= CompStartDate then begin
                                    if SODate <= CompEndingDaate then begin
                                        if MainItemCodeSetup = ItemCode then begin
                                            //if MainItemQtySetup = QtyMainItemSO then begin
                                            i := i + 1;

                                            ArrayCompGroupId[i] := CompGroupIdCust;

                                            if i = 1 then begin
                                                CompGroupIdAll := ArrayCompGroupId[i]
                                            end
                                            else begin
                                                PrevGroupId := ArrayCompGroupId[i - 1];
                                                if PrevGroupId <> ArrayCompGroupId[i] then begin
                                                    CompGroupIdAll := CompGroupIdAll + '|' + ArrayCompGroupId[i]
                                                end;
                                            end;
                                            //end;
                                        end;
                                    end;
                                end;

                            end;
                        until COMPMapping.Next = 0;

                    //SODateText := FORMAT(SODate);

                    if ItemCode = '' then begin
                        Message('Please select an item ');
                        exit
                    end;

                    if CompGroupIdAll = '' then begin
                        Message('No Complimentary Item Available');
                        exit
                    end;

                    QtyActual := Rec.Quantity;
                    CompLineNo := Rec."Line No." + 1000;
                    // ItemMaster.Get(ItemCode);
                    // ItemCodeCompliment := ItemMaster."Complimentary Item No.";
                    // QtyReq := ItemMaster."Main Item Qty";
                    // QtyCompliment := ItemMaster."Complimentary Qty";
                    // CompItemUOM := ItemMaster."Base Unit of Measure";
                    COMPSetupRec.SetFilter(CompGroupId, CompGroupIdAll);
                    //COMPSetupRec.SetFilter(CompBeginDate, '<=%1', SODate);
                    //COMPSetupRec.SetFilter(CompEndingDate, '>=%1', SODate);

                    PAGE.Run(PAGE::PgCompItemPopUp, COMPSetupRec);

                    If QtyActual = QtyReq then begin
                        //    CUInsertSOLine.SOInsertComplimentary(Rec, QtyCompliment, ItemCodeCompliment, CompLineNo, CompItemUOM);
                    end
                    else begin
                        // Message('No Complimentary item for this item');
                        // exit
                    end;
                end;
            }

        }
    }


    var
        QtyReq: Decimal;
        QtyActual: Decimal;
        CompLineNo: Integer;
        ItemCode: Code[20];
        ItemCodeCompliment: Code[20];
        ItemMaster: Record Item;
        CompItemUOM: Text;
        //SODate: DateTime;
        ArrayCompGroupId: array[10] of Code[20];
        CUUpdateSORef: codeunit CUCompSORef;

    procedure InsertCompItem(MainItem: Text; CompItem: text)//; MainReqQty: Decimal; CompQty: Decimal)
    var

    begin

    end;




}