page 80126 "MR Consignment List"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "MR Consignment Header";
    UsageCategory = Lists;
    CardPageId = "MR Consignment Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."Material Req. No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(RequesterID; Rec.RequesterID)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
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
                SubPageLink = "Table ID" = CONST(database::"MR Consignment Header"), "No." = FIELD("Material Req. No.");
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
                    lRec: Record "MR Consignment Header";
                begin
                    Rec.TestField(Rec."Material Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Material Req. No.", Rec."Material Req. No.");

                end;
            }
        }
    }
}
