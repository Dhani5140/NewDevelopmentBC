page 70004 PgCompItemPopUp
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = TblCompItemSetup;
    Caption = 'Select Complimentary Item';
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                // field(selected; selected)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Select';
                // }
                field("Comp Group Id"; Rec.CompGroupId)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                    ToolTip = 'Select This Item';

                    trigger OnDrillDown() // When complimentary group id is clicked
                    var
                        CompItemCode: text;
                        MainItemCode: Text;
                        QtyMainReq: Decimal;
                        QtySupp: Decimal;
                        CompMethod: Option;

                    begin
                        CompItemCode := Rec.ComplimentaryItem1;
                        MainItemCode := rec.CompMainItem;
                        QtyMainReq := rec."Main Item Qty";
                        QtySupp := rec."Complimentary Qty1";
                        CompMethod := rec.CompMethod;

                        // if CompMethod = 1 then begin
                        //     Message('CUMMULATIVE !');
                        // end;

                        CUInsert.SOInsertComplimentaryNew(MainItemCode, CompItemCode, QtyMainReq, QtySupp, CompMethod);
                        CurrPage.Close();

                        // SOLinePageExt.Activate();
                        // SOLinePageExt.InsertCompItem(MainItemCode, CompItemCode);
                        //CUInsert.GetFromCompPopUp(MainItemCode, CompItemCode);

                    end;
                }

                field(Description; Rec.CompGroupDesc)
                {
                    ApplicationArea = All;

                }


                field("Complimentary Item"; Rec.ComplimentaryItem1)
                {
                    ApplicationArea = All;
                }

                field("Complimentary item Qty"; Rec."Complimentary Qty1")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                PromotedIsBig = true;
                Promoted = true;

                trigger OnAction();
                begin
                    //CurrPage.Close(CUInsert.SOInsertComplimentary(););
                end;
            }
        }
    }

    local procedure InsertSOLine(SOLine: Record "Sales Line")
    begin
        //SOLine := rec;
    end;

    var
        ItemCode: text;
        SOLine: Record "Sales Line";
        SOLinePageExt: Page "Sales Order Subform";
        //SOHeaderPage: Page "Sales Order";

        CUInsert: Codeunit CUInsertSalesLine;
        CUSoRef: Codeunit CUCompSORef;

}