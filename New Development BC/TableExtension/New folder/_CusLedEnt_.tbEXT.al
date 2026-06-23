tableextension 51124 CusLedEnt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50100; "Rem. Amt for WHT"; Decimal)
        {
            Caption = 'Rem. Amt for WHT';
        }
        field(50101; "Rem. Amt"; Decimal)
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