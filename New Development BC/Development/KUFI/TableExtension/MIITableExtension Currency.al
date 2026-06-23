tableextension 70118 MIITExtCER extends "Currency Exchange Rate"
{
    fields
    {
        field(50001; "Exchange Rate Amount BS"; Decimal)
        {
            Caption = 'Exchange Rate Amount BS';
            DecimalPlaces = 1 : 6;
            MinValue = 0;
        }
        field(50002; "Exchange Rate Amount PL"; Decimal)
        {
            Caption = 'Exchange Rate Amount PL';
            DecimalPlaces = 1 : 6;
            MinValue = 0;
        }
    }
}