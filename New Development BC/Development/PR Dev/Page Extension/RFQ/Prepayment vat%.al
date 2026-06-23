pageextension 80181 prepvatpos extends "Purchase Order Subform"
{
    layout
    {

        addafter(Description)
        {
            field("Prepayment VAT %"; Rec."Prepayment VAT %")
            {
                ApplicationArea = All;
                Editable = true;
            }
            //106001 ∙ Fabrikam, Inc.
            field("Prepmt. Amount Inv. Incl. VAT"; Rec."Prepmt. Amount Inv. Incl. VAT")
            {
                ApplicationArea = all;
                Editable = true;
            }

            field("Prepmt. Amt. Incl. VAT"; Rec."Prepmt. Amt. Incl. VAT")
            {
                ApplicationArea = all;
                Editable = true;
            }




        }
    }
    var
        myInt: Integer;
}
