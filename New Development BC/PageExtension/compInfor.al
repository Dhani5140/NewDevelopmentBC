pageextension 50138 COMPINFO extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field(Signature; Rec.Signature)
            {
                ApplicationArea = BASIC, SUITE;
                Caption = 'Signature';
            }
            field("Name PIC RFQ"; Rec."Name PIC RFQ")
            {
                ApplicationArea = all;
            }
            field("Role PIC RFQ"; Rec."Role PIC RFQ")
            {
                ApplicationArea = all;
            }
        }
    }
}