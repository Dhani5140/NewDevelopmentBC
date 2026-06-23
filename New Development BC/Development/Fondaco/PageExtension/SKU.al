pageextension 70006 MIIPEextSKU extends "Stockkeeping Unit Card"
{
    layout
    {

        addafter("Qty. on Asm. Component")
        {
            field("Production BOM No. 2"; Rec."Production BOM No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }
}