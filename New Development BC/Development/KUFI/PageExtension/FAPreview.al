pageextension 70015 PgExtFAGLPrev extends "FA Ledger Entries Preview"
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