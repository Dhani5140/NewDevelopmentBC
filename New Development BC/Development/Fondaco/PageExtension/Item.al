pageextension 70004 PgExtitemMaster extends "Item Card"
{
    layout
    {
        addlast("Prices & Sales")
        {
            field("Complimentary Item No."; rec."Complimentary Item No.")
            {
                ApplicationArea = All;
                Visible = false;

            }

            field("Main Item Qty"; rec."Main Item Qty")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Complimentary Qty"; rec."Complimentary Qty")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}