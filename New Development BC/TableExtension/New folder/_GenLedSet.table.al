tableextension 51135 genledset extends "General Ledger Setup"
{
    fields
    {
        field(11604; "Enable GST (Australia)"; Boolean)
        {
            Caption = 'Enable GST (Australia)';

            // trigger OnValidate()
            // begin
            //     if not BASSetupName.ReadPermission then
            //         Error(Text1500003);
            // end;
        }
        field(28042; "Manual Sales WHT Calc."; Boolean)
        {
            Caption = 'Manual Sales WHT Calc.';
        }
        field(28046; "Round Amount for WHT Calc"; Boolean)
        {
            Caption = 'Round Amount for WHT Calc';
        }
        field(28047; "Enable WHT"; Boolean)
        {
            Caption = 'Round Amount for WHT Calc';
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