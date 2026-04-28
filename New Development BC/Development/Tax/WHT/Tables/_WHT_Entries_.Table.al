table 51134 "WHT Entries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            //AutoIncrement = true;

        }
        field(2; "Gen Bus Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(3; "Gen Prod Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Document Type"; Enum "Gen. Journal Document Type")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Type"; enum "General Posting Type")
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Base"; Decimal)
        {

        }
        field(9; Amount; Decimal)
        {

        }
        field(12; Billtopay; code[20])
        {

        }
        field(14; "User ID"; Code[50])
        {
            TableRelation = USER."User Name";
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Source Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Reason Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reason Code";
        }
        field(17; "Vendor No."; Code[20])
        {

        }

    }

    keys
    {
        key(Key1; "Entry No")
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