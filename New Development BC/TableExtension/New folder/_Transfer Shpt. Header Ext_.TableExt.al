tableextension 80120 "Transfer Shpt. Header Ext" extends "Transfer Shipment Header"
{
    fields
    {
        field(50000; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Original No. from System"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
