table 52224 ExpressionExample
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = SystemMetadata;
        }

        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(3; NumericExpression; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Numeric Expression';
        }

        field(4; RelationalExpression; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Relational Expression';
        }

        field(5; BooleanExpression; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Boolean Expression';
        }

        field(6; ConcatenatedString; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Concatenated String';
        }
    }

    keys
    {
        key(PK; ID) { Clustered = true; }
    }
}
