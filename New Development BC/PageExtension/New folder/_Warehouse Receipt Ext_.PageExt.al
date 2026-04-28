pageextension 80133 "Warehouse Receipt Ext" extends "Warehouse Receipt"
{
    layout
    {
        addafter("Location Code")
        {
            field("No. Polisi"; Rec."No. Polisi")
            {
                ApplicationArea = All;
            }
            field("No. Surat Jalan"; Rec."No. Surat Jalan")
            {
                ApplicationArea = All;
            }
            field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            {
                ApplicationArea = All;
            }
            // field("Shipping Date";Rec."Shipping Date")
            // {
            //     ApplicationArea = All;
            // }
        }
    }
    var
        myInt: Integer;
}
