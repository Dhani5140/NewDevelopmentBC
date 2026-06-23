Table 50100 "Cash Flow Buffer"
{
    TableType = Temporary;
    Caption = 'Cash Flow Buffer';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Grouping Account No."; Code[20])
        {
            Caption = 'Grouping Account No.';
        }
        field(11; "Grouping Account Name"; Text[100])
        {
            Caption = 'Grouping Account Name';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(30; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(40; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(50; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
