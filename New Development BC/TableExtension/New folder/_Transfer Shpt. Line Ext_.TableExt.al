tableextension 80123 "Transfer Shpt. Line Ext" extends "Transfer Shipment Line"
{
    fields
    {
        field(50000; "Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
