pageextension 51134 Purchase_Invoice extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("WHT Code"; rec."WHT Code")
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

    var
        myInt: Integer;
}