table 70006 TblCompSORef
{
    //DataClassification = ToBeClassified;

    fields
    {
        field(1; "Urutan"; integer)
        {
            DataClassification = ToBeClassified;

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
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

}