namespace PR.PPB;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Inventory.Ledger;
using PR.PB;

table 60104 PPBLine
{
    fields
    {
        field(1; "No."; code[20])
        {
            TableRelation = Item where(Blocked = const(false), "Purchasing Blocked" = const(false));
        }

        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = PPBHeader."No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Part Number"; Text[100])
        {

        }
        field(5; "Item Description"; Text[100])
        {

        }
        field(6; "Quantity"; Decimal)
        {

        }
        field(7; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(9; "Keterangan"; Text[100])
        {

        }
        field(10; "Qty Requested"; Decimal)
        {
            Caption = 'Qty Requested';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Stock"; Decimal)
        {
            Caption = 'Stock';
            DecimalPlaces = 0 : 5;
            Editable = false;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                "Location Code" = field("Location Code")));
            FieldClass = FlowField;


        }
        field(12; "Qty. to Order"; Decimal)
        {
            Caption = 'Qty. to Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(13; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
        }
        field(14; Total; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Total';
            MinValue = 0;
        }
        field(15; "PB Document No."; Code[20])
        {
            Caption = 'PB Document No.';
            Editable = false;
        }
        field(16; "PB Line No."; Integer)
        {
            Caption = 'PB Line No.';
            Editable = false;
        }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

}