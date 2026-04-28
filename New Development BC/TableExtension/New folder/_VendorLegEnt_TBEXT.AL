tableextension 51143 VenLedEnt extends "Vendor Ledger Entry"
{
    fields
    {
        field(28040; "Rem. Amt for WHT"; Decimal)
        {
            Caption = 'Rem. Amt for WHT';
        }
        field(28041; "Rem. Amt"; Decimal)
        {
            Caption = 'Rem. Amt';
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