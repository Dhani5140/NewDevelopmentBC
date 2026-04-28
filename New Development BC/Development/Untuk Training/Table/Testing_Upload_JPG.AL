table 52234 ImageTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Image ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Image Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Image Blob"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Memo;
        }
        field(4; "Image Media"; Media)
        {
            DataClassification = ToBeClassified;
            Caption = 'Image File';
        }
    }

    keys
    {
        key(PK; "Image ID")
        {
            Clustered = true;
        }
    }
}
