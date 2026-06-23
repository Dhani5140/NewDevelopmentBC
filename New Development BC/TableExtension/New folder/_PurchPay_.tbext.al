tableextension 51146 PurPay extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "WHT Certificate No. Series"; Code[20])
        {
            Caption = 'WHT Certificate No. Series';
            TableRelation = "No. Series";
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