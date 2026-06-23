page 80129 "PR Consignment List"
{
    PageType = List;
    SourceTable = "PR Consignment Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PR Consignment Card";
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
                SubPageLink = "Table ID" = CONST(database::"PR Consignment Header"), "No." = FIELD("Purchase Req. No.");
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
                    lRec: Record "PR Consignment Header";
                begin
                    Rec.TestField(Rec."Purchase Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Purchase Req. No.", Rec."Purchase Req. No.");

                end;
            }
        }
    }
}
