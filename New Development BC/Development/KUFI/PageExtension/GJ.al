pageextension 70012 PgExtGJ extends "General Journal"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT Amount"; Rec."WHT Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}