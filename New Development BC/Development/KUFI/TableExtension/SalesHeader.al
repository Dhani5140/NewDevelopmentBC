tableextension 70013 PgExtSH extends "Sales Header"
{
    fields
    {
        field(50100; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
    }

}