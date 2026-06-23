tableextension 70012 PgExtPIH extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
    }

}