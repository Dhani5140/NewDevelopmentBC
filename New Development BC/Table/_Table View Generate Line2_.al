table 81116 "Table View Generate Line2"
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
        field(6; "Transaction Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "00","01","02","03","04","05","06","07","08","09";
        }

        field(8; "Transaction Code1"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "01","02","03","04","05","06","07","08","09";
            FieldClass = FlowField;
            CalcFormula = lookup("Table View Generate Header"."Trasaction Code" where("Faktur Pajak ID" = field("Document No.")));
        }

        field(7; "Branch Code"; Code[3])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Document No1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Faktur Pajak No", "Line Number")
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
        TestField(Status, Status::FREE);
    end;

    trigger OnRename()
    begin

    end;

}