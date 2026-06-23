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
            TableRelation = Vendor."No.";
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

    procedure CopyFromGenJnlLine(GenJnlLine: Record "Gen. Journal Line")
    begin
        "Entry No" := GetLastEntryNo() + 1;
        Type := GenJnlLine."Gen. Posting Type";
        Base := GenJnlLine."VAT Base Amount";
        Amount := GenJnlLine."WHT Amount";
        "Document Type" := GenJnlLine."Document Type";
        "Posting Date" := GenJnlLine."Document Date";
        "Document No." := GenJnlLine."Document No.";
        "Source Code" := GenJnlLine."Source Code";
        "Reason Code" := GenJnlLine."Reason Code";
        "Gen Bus Posting Group" := GenJnlLine."WHT Business Posting Group";
        "Gen Prod Posting Group" := GenJnlLine."WHT Product Posting Group";
        "User ID" := CopyStr(UserId(), 1, MaxStrLen("User ID"));
        Billtopay := GenJnlLine."Bill-to/Pay-to No.";
    end;

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No")))
    end;

}