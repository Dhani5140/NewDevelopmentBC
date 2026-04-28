pageextension 80146 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(SalesLines)
        {
            group("Tax Setup")
            {
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Tax-Document Post"; Rec."Tax-Document Post")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        myInt: Integer;
        AreaCode: Code[20];
}
