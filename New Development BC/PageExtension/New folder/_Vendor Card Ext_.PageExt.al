pageextension 80140 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addafter("Address & Contact")
        {
            group("Tax Module")
            {
                // field("VAT Reg. No."; Rec."VAT Registration No.")
                // {
                //     ApplicationArea = All;
                //     ShowMandatory = true;
                // }
                field("NPWP NO."; Rec."NPWP NO.")
                {
                    ApplicationArea = ALL;
                    ShowMandatory = true;
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
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Creditable; Rec.Creditable)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
            }
        }

        // addafter("Tax Module")
        // {
        //     group(WHT)
        //     {
        //         field("WHT Business Posting Group"; rec."WHT Business Posting Group")
        //         {

        //         }
        //         field("WHT Posting Group"; rec."WHT Posting Group")
        //         {

        //         }
        //         field("WHT Product Posting Group"; rec."WHT Product Posting Group")
        //         {

        //         }
        //         field("Apply WHT"; rec."Apply WHT")
        //         {
        //             ApplicationArea = All;
        //         }
        //         field("WHT Code"; rec."WHT Code")
        //         {
        //             ApplicationArea = All;
        //         }
        //     }
        // }
        addafter("VAT Bus. Posting Group")
        {
            field("WHT Business Posting Group"; Rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        myInt: Integer;
}
