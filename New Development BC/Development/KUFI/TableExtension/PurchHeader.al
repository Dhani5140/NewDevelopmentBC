tableextension 70010 PgExtPH extends "Purchase Header"
{
    fields
    {
        field(50101; "WHT Amount"; Decimal)
        {
            Caption = 'WHT Amount';
            Editable = false;
        }
        field(50100; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
    }

}