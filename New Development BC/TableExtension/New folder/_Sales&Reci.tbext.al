tableextension 51150 sales_reci extends "Sales & Receivables Setup"
{
    fields
    {
        field(28040; "Print WHT on Credit Memo"; Boolean)
        {
            Caption = 'Print WHT on Credit Memo';
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