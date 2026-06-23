tableextension 70014 PgExtSIH extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
    }

}