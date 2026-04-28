pageextension 80139 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(Shipping)
        {
            group("Tax Module")
            {
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                // field("NPWP"; Rec."VAT Registration No.")
                // {
                //     ApplicationArea = All;
                //     ShowMandatory = true;
                // }
                field("NPWP No"; Rec."NPWP No")
                {
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = all;

                }
                field("NPWP Name"; Rec."NPWP Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("NPWP Address"; Rec."NPWP Address")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("NPWP Address 2"; Rec."NPWP Address 2")
                {
                    ApplicationArea = All;
                }
                field("No. KTP"; Rec."No. KTP")
                {
                    ApplicationArea = All;
                }
                field("No. SPPKP"; Rec."No. SPPKP")
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
            }
        }
    }
    var
        myInt: Integer;
}
