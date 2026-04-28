pageextension 80138 "Sales Journal Ext" extends "Sales Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("Tax No."; Rec."Tax No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(Reporting)
        {

        }
    }
    var
        myInt: Integer;
}
