namespace PR.RFQ;

using Microsoft.Inventory.Item;
using PR.VSL;
using Microsoft.Purchases.Vendor;
using PR.PPB;

table 60106 Rfqline
{


    fields
    {
        field(1; "Item No."; code[20])
        {
            TableRelation = Item where(Blocked = const(false), "Purchasing Blocked" = const(false));

        }
        field(2; "No."; code[20])
        {
            Caption = 'Document No';
            DataClassification = ToBeClassified;
        }

        field(3; "Line No."; Integer)
        {
            Caption = 'Line No';
        }
        field(4; "Part Number"; text[100])
        {

        }

        field(5; "Item Description"; Text[100])
        {

        }

        field(6; "Quantity"; Decimal)
        {

        }
        field(7; "Vendor No"; Code[20])
        {
            Caption = 'Vendor No';
            TableRelation = Vendor;
        }
        field(8; UoM; CODE[20])
        {
            Caption = 'UoM';
        }
        field(9; "Vendor Name"; text[100])
        {
            Caption = 'Vendor Name';

        }
        field(10; "PPB Document No."; Code[20])
        {
            Caption = 'PPB Document No.';
            Editable = false;
            TableRelation = PPBHeader."No.";


        }
        field(11; "PPB Line No."; Integer)
        {
            Caption = 'PB Line No.';
            Editable = false;
        }
        field(12; "Document No VSH"; Code[20])
        {
            Caption = 'VS Document';
            Editable = false;
            TableRelation = "Vendor Selection Header"."No.";

        }
        field(13; "Unit Amount"; Decimal)
        {

        }





    }

    keys
    {
        key(Key1; "No.", "Line No.", "Document No VSH", "PPB Document No.")
        {
            Clustered = true;
        }
    }


}