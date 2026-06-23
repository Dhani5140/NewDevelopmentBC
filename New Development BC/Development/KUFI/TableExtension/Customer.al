tableextension 70016 PgExtSust extends Customer
{
    fields
    {
        field(50100; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
    }

}