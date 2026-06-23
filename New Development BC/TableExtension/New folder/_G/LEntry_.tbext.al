tableextension 51145 "G/L Register" extends "G/L Register"
{
    fields
    {
        field(50100; "From WHT Entry No."; Integer)
        {
            Caption = 'From WHT Entry No.';
            TableRelation = "WHT Entry";
        }
        field(50101; "To WHT Entry No."; Integer)
        {
            Caption = 'To WHT Entry No.';
            TableRelation = "WHT Entry";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}