namespace PR.PPB;

using Microsoft.Inventory.Item;

page 60110 "PPBDetail"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = PPBLine;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        UpdateItem();
                    end;
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Qty Requested"; Rec."Qty Requested")
                {
                    ApplicationArea = all;
                }
                field(Stock; Rec.Stock)
                {
                    ApplicationArea = all;
                }
                field("Qty. to Order"; Rec."Qty. to Order")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = all;
                }
                field(Keterangan; Rec.Keterangan)
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
            action(Check)
            {
                ApplicationArea = Suite;
                Caption = 'Check Stock';
                Ellipsis = true;
                Image = Warehouse;
                ToolTip = 'Select a posted purchase receipt for the item that you want to assign the item charge to.';

                trigger OnAction()
                var
                    itm: Record Item;
                begin
                    itm.SetRange("No.", rec."No.");
                    itm.SetRange("Location Filter", rec."Location Code");
                    Page.Run(60103, itm);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UnitCost(Rec);
        TotalA();
    end;

    trigger OnAfterGetRecord()
    begin
        UnitCost(Rec);
        TotalA();
    end;

    procedure UnitCost(PPBLine: Record PPBLine)
    var
        Item: Record Item;
    begin
        Item.SetRange("No.", PPBLine."No.");
        if Item.FindSet() then begin
            PPBLine."Unit Cost" := Item."Unit Cost";
            PPBLine.Modify();
        end;
    end;

    procedure TotalA()
    begin
        Rec.Total := Rec."Qty. to Order" * Rec."Unit Cost";
    end;

    local procedure UpdateItem()
    var
        Item: Record Item;
    begin
        item.SetRange("No.", rec."No.");
        if Item.FindSet() then begin
            Rec."Item Description" := Item.Description;
            Rec."Unit of Measure Code" := Item."Base Unit of Measure";
            rec."Part Number" := item.part_number;
            Rec.Modify();
        end;
    end;

    var
        SourceQTY: decimal;
}