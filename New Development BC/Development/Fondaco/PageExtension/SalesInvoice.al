pageextension 70002 MIIPEextSI extends "Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
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