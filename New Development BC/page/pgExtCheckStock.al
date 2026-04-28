namespace PR.PB;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Inventory.Location;

page 60103 "Check Stock"
{
    Caption = 'Check Stock';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;

                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(part_number; Rec.part_number)
                {
                    ApplicationArea = all;
                }

                field(QTY123; Rec.QTY123)
                {
                    ApplicationArea = all;
                }
                field(QTY1234; Rec.QTY1234)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity Requester';
                    DecimalPlaces = 0 : 3;
                }

                field(QTY123456; Rec.QTY123456)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity Available';
                    DecimalPlaces = 0 : 3;
                    trigger OnValidate()
                    begin

                        rec.QTY123456 := rec.QTY123 - rec.QTY1234;

                    end;
                }






            }
        }
    }
    var

        ItemLedgerEntry: record "Item Ledger Entry";
        MatrixRecords: array[32] of Record Location;
        MATRIX_CellData: array[32] of Decimal;
        MATRIX_ColumnCaption: array[32] of Text[1024];

    local procedure MatrixOnDrillDown(ColumnID: Integer)
    begin
        ItemLedgerEntry.SetCurrentKey(
          "Item No.", "Entry Type", "Variant Code", "Drop Shipment", "Location Code", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", Rec."No.");
        ItemLedgerEntry.SetRange("Location Code", MatrixRecords[ColumnID].Code);
        OnMatrixOnDrillDownOnAfterItemLedgerEntrySetFilters(Rec, ItemLedgerEntry, ColumnID);
        PAGE.Run(0, ItemLedgerEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnMatrixOnDrillDownOnAfterItemLedgerEntrySetFilters(var Item: Record Item; var ItemLedgerEntry: Record "Item Ledger Entry"; ColumnID: integer)
    begin
    end;

    trigger OnAfterGetCurrRecord()
    begin
        rec.QTY123456 := (rec.QTY123) - (rec.QTY1234);
    end;

    trigger OnAfterGetRecord()
    begin
        rec.QTY123456 := (rec.QTY123) - (rec.QTY1234);
    end;
}

