tableextension 80136 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "Allow Cancel PR Consignment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        myInt: Integer;
}
