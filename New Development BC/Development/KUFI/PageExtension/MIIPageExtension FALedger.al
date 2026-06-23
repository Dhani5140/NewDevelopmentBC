pageextension 70116 PgExtFALed extends "FA Ledger Entries"
{
    layout
    {
        addbefore(Amount)
        {
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = all;
            }
        }
    }
}