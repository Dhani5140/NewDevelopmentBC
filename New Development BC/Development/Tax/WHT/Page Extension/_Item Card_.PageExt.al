pageextension 80112 "Item Card" extends "Item Card"
{
    layout
    {
        addafter("Type")
        {
            field("PPH 22"; Rec."PPH 22")
            {
                ApplicationArea = All;
            }
            field(part_number; Rec.part_number)
            {
                Caption = 'Part Number';
                ApplicationArea = All;
            }
        }
        addafter(Inventory)
        {
            group(WHT)
            {
                field("WHT Business Posting Group"; rec."WHT Business Posting Group")
                {

                }
                field("WHT Posting Group"; rec."WHT Posting Group")
                {

                }
                field("WHT Product Posting Group"; rec."WHT Product Posting Group")
                {

                }
            }
        }
    }
    var
        myInt: Integer;
}
