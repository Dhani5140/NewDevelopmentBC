table 50104 TemporaryTransfer
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';

        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(8; "Debit Amount"; Decimal)
        {
            //AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(9; "Credit Amount"; Decimal)
        {
            //AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(10; Transfer; Boolean)
        {
            Caption = 'Transfer';
        }
        field(11; Type; Enum "G/L Account Report Type")
        {
            CalcFormula = Lookup("G/L Account"."Income/Balance" where("No." = field("Account No.")));
            FieldClass = FlowField;
        }
        field(12; Date; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {

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