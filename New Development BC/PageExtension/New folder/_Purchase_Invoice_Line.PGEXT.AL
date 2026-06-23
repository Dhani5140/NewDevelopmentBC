pageextension 51134 Purchase_Invoice extends "Purch. Invoice Subform"
{
    layout
    {
        modify("No.")
        {
            ApplicationArea = all;
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin

            end;
        }
        addafter(Description)
        {
            // field("WHT Code"; rec."WHT Code")
            // {
            //     ApplicationArea = all;
            //     Editable = true;
            // }
            field("WHT Product Posting Group"; Rec."WHT Product Posting Group")
            {
                ApplicationArea = all;
            }
            field("Maintenance Code"; Rec."Maintenance Code")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}