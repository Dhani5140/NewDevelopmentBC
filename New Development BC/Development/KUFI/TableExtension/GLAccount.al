tableextension 70017 TbExtGLA extends "G/L Account"
{
    fields
    {
        field(70003; "WHT Bus. Posting Group"; Code[20])
        {
            Caption = 'WHT Bus. Posting Group';
            DataClassification = SystemMetadata;
            TableRelation = "WHT Buss Posting Group";
        }
        field(70004; "WHT Prod. Posting Group"; Code[20])
        {
            Caption = 'WHT Prod. Posting Group';
            DataClassification = SystemMetadata;
            TableRelation = "WHT Product Posting Group";
        }
    }
}