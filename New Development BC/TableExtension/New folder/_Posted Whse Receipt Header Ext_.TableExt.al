tableextension 80128 "Posted Whse Receipt Header Ext" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50000; "No. Surat Jalan"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Tanggal Surat Jalan"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "No. Polisi"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Shipping Date"; Date)
        {
            DataClassification = ToBeClassified;
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
