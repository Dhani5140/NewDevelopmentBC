namespace PR.PB;

using Microsoft.Inventory.Item;
using PR;
page 60106 "PBDetailwar"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = PBLine;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.1"; Rec."No.")
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
                field(Quantity; Rec.Quantity)
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
                field(Keperluan; Rec.Keperluan)
                {
                    ApplicationArea = all;
                }
                field(genprodposting; Rec.genprodposting)
                {
                    ApplicationArea = all;
                }
                field(Departement; Rec.Departement)
                {
                    ApplicationArea = all;
                    Caption = 'Department';
                    trigger OnValidate()
                    begin
                        Analisispage();
                    end;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    ApplicationArea = all;
                    Caption = 'Unit Code';

                    trigger OnValidate()
                    begin
                        Analisispage();
                    end;
                }
                field("Qty to Deliver"; Rec."Qty to Deliver")
                {
                    ApplicationArea = all;
                }
                field("Quantity Delivered"; Rec."Quantity Delivered")
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
            action("Item Availability")
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
    local procedure Analisispage()
    var
        Analisispage: Record Analisispage;
    begin
        Analisispage.SetFilter("Dept Code", '%1', rec.Departement);
        Analisispage.SetFilter("Unit Code", '%1', rec."Unit Code");
        if Analisispage.FindSet() then begin

            rec.genprodposting := Analisispage.COA;
            rec.Modify();
            rec.Validate(genprodposting);
        end;
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



