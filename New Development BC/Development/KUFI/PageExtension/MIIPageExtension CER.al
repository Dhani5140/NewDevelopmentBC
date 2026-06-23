pageextension 70113 MIIPgExtCER extends "Currency Exchange Rates"
{
    layout
    {
        addafter("Fix Exchange Rate Amount")
        {
            field("Exchange Rate Amount BS"; Rec."Exchange Rate Amount BS")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Exchange Rate Amount PL"; Rec."Exchange Rate Amount PL")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }
}