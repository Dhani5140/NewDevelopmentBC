table 81113 "Table View Generate Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Faktur Pajak No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Status; enum "View Generate")
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Bill-to / Pay-To No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Line Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Faktur Pajak No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}