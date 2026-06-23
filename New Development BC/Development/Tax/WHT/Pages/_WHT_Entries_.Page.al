page 51134 "WHT Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WHT Entries";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; rec."Entry No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gen Bus Posting Group"; rec."Gen Bus Posting Group")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Gen Prod Posting Group"; rec."Gen Prod Posting Group")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(Billtopay; Rec.Billtopay)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}