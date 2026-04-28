table 51110 "Tax Setup2"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "WHT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "WHT Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "WHT Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "WHT Payable Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(5; "Expense Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
    keys
    {
        key(Key1; "WHT Code")
        {
            Clustered = true;
        }
    }
}
