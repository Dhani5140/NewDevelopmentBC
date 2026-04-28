tableextension 51138 salescrmemoline extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50022; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Buss Posting Group";
        }
        field(50023; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group";
        }
        field(50024; "WHT Absorb Base"; Decimal)
        {
            Caption = 'WHT Absorb Base';
        }
        field(50025; "WHT %"; Decimal)
        {
            TableRelation = "WHT Posting Setup"."WHT %";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}