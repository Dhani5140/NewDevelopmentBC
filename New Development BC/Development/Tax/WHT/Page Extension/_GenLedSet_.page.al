pageextension 51147 GenLedSet extends "General Ledger Setup"
{
    layout
    {
        addafter("Bank Account Nos.")
        {
            field("Enable WHT"; rec."Enable WHT")
            {
                ApplicationArea = all;
                Caption = 'Enable';
            }
            field("Round Amount for WHT Calc"; rec."Round Amount for WHT Calc")
            {
                ApplicationArea = all;
            }
            field("Enable GST (Australia)"; rec."Enable GST (Australia)")
            {
                ApplicationArea = all;
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