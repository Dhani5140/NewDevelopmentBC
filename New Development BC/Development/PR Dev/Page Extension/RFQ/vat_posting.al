pageextension 80180 vatpos extends "VAT Posting Setup"
{
    layout
    {

        addafter(Description)
        {
            field("Non-Deductible VAT %"; Rec."Non-Deductible VAT %")
            {
                ApplicationArea = All;
                Editable = true;
            }


        }
    }
    var
        myInt: Integer;
}
