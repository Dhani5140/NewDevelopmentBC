tableextension 80125 "Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        field(50000; "Unit Group Dimension"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
    }
}
