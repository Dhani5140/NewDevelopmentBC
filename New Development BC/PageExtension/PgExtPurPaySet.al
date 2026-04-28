namespace PR;

using Microsoft.Purchases.Setup;

pageextension 60101 PgPurPaySet extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Invoice Nos.")
        {
            field("PB Noseries"; Rec."PB Noseries")
            {
                ApplicationArea = suite;
                Importance = Additional;
            }
            field("PPB Noseries"; Rec."PPB Noseries")
            {
                ApplicationArea = suite;
                Importance = Additional;
            }
            field("RFQ Noseries"; Rec."RFQ Noseries")
            {
                ApplicationArea = suite;
                Importance = Additional;
            }

            field(vsl; Rec.vsl)
            {
                ApplicationArea = Suite;
                Importance = Additional;
            }





        }
    }



}