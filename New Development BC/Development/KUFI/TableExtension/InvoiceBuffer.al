tableextension 70011 PgExtIPB extends "Invoice Posting Buffer"
{
    fields
    {
        field(70001; "WHT %"; Decimal)
        {
            Caption = 'WHT %';
            DataClassification = SystemMetadata;
            DecimalPlaces = 1 : 1;
        }
        field(70002; "WHT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'WHT Amount';
            DataClassification = SystemMetadata;
        }
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
        field(70005; "QTY FA"; Decimal)
        {
            Caption = 'QTY FA';
        }
    }
}