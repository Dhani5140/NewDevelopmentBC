pageextension 80148 "User Setup Ext" extends "User Setup"
{
    layout
    {
        addbefore("Allow Posting From")
        {
            field("Allow Cancel PR Consignment"; Rec."Allow Cancel PR Consignment")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;
}
