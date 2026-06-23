page 80116 "PR Asset List"
{
    PageType = List;
    SourceTable = "PR Asset Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PR Asset Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purchase Req. No."; Rec."Purchase Req. No.")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment FactBox"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(database::"PR Asset Header"), "No." = FIELD("Purchase Req. No.");
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "PR Asset Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Purchase Req. No.", Rec."Purchase Req. No.");

                end;
            }
        }
    }
}
