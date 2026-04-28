namespace PR.PB;

using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Finance.GeneralLedger.Setup;

table 60101 PBLine
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
            TableRelation = PBHeader."No.";
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
        field(9; "Keperluan"; Text[100])
        {

        }
        field(10; "Qty to Deliver"; Decimal)
        {
            Caption = 'Qty to Deliver';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Quantity Delivered"; Decimal)
        {
            Caption = 'Quantity Delivered';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(12; genprodposting; Code[20])
        {
            Caption = 'Gen Prod Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(13; "Departement"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(14; "Unit Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false));
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