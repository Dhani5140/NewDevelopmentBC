table 70007 TblCompSOReference
{
    //DataClassification = ToBeClassified;

    fields
    {
        field(1; "Urutan"; integer)
        {
            DataClassification = ToBeClassified;

        }

        field(2; "User Name"; Code[50])
        {
            Caption = 'User Name';
        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(4; "Line No."; Integer)

        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; Urutan)
        {
            Clustered = true;
        }
    }
}