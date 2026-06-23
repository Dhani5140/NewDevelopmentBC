page 50106 Temporary
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = TemporaryTransfer;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = true;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    Editable = true;

                }
            }
        }
    }

}
