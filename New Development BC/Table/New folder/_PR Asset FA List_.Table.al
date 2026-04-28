table 80111 "PR Asset FA List"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = True;
        }
        field(2; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "FA No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            var
                lRecFA: Record "Fixed Asset";
            begin
                TestField("FA No.");
                lRecFA.RESET;
                lRecFA.GET("FA No.");
                "FA Description" := lRecFA.Description;
            end;
        }
        field(7; "FA Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Testfield("FA No.");
                VALIDATE("Line Amount", Rec.Quantity * Rec."Unit Price");
            end;
        }
        field(9; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Testfield("FA No.");
                VALIDATE("Line Amount", Rec.Quantity * Rec."Unit Price");
            end;
        }
        field(10; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header".Status WHERE("No." = field("PO No.")));
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Line No." := getLastLine("PO No.", "PO Line No.", "Purchase Req. No.", "Purchase Req. Line No.");
    end;

    trigger OnModify()
    begin
        TestField("Status", "Status"::Open);
    end;

    trigger OnDelete()
    begin
        TestField("Status", "Status"::Open);
    end;

    trigger OnRename()
    begin
    end;

    local procedure getLastLine(PONo: Code[20]; POLineNo: Integer; PRNo: Code[20]; PRLineNo: Integer): Integer
    var
        lRec: Record "PR Asset FA List";
    begin
        lRec.RESET;
        lRec.SETRANGE("PO No.", PONo);
        lRec.SETRANGE("PO Line No.", POLineNo);
        lRec.SETRANGE("Purchase Req. No.", PRNo);
        lRec.SETRANGE("Purchase Req. Line No.", PRLineNo);
        IF lRec.FINDLAST THEN
            EXIT(lRec."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;
}
