pageextension 70011 PgExtGLA extends "G/L Account Card"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Bus. Posting Group"; Rec."WHT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT Prod. Posting Group"; Rec."WHT Prod. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}