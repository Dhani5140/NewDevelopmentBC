tableextension 80129 "Source Code SetupExt" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Inventory Shipment"; Code[10])
        {
            Caption = 'Inventory Shipment';
            TableRelation = "Source Code";
        }
        field(50001; "Item Consumption"; Code[10])
        {
            Caption = 'Item Consumption';
            TableRelation = "Source Code";
        }
    }
    keys
    {
        // Add changes to keys here
    }
    fieldgroups
    {
        // Add changes to field groups here
    }
    var
        myInt: Integer;
}
