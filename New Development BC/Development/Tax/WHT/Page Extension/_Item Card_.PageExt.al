pageextension 80112 "Item Card" extends "Item Card"
{
    layout
    {
        addafter("Type")
        {
            field(part_number; Rec.part_number)
            {
                Caption = 'Part Number';
                ApplicationArea = All;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}
