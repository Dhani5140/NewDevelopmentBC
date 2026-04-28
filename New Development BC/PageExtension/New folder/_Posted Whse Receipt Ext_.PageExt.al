pageextension 80134 "Posted Whse Receipt Ext" extends "Posted Whse. Receipt"
{
    layout
    {
        addafter("Location Code")
        {
            field("No. Polisi"; Rec."No. Polisi")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("No. Surat Jalan"; Rec."No. Surat Jalan")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            // field("Shipping Date";Rec."Shipping Date")
            // {
            //     ApplicationArea = All;
            //     Editable = FALSE;
            // }
        }
    }
    var
        myInt: Integer;
}
