page 50166 "Material Req. List deliver"
{
    ApplicationArea = All;
    Caption = 'Material Request List Deliver';
    PageType = List;
    SourceTable = "Material Req. Header";
    UsageCategory = Lists;
    CardPageId = "Material Req. Card deliver";
    Editable = false;
    SourceTableView = where(Status = filter(Released | Processed | Closed | "Partial Receive / Processed On PR"));

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
                SubPageLink = "Table ID" = CONST(database::"Material Req. Header"), "No." = FIELD("Material Req. No.");
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
                    lRec: Record "Material Req. Header";
                begin
                    Rec.TestField(Rec."Material Req. No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Material Req. No.", Rec."Material Req. No.");

                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        war: Record "Warehouse Employee";
        wms: Codeunit "WMS Management";

    begin
        rec.SetFilter("Location Code", wms.GetWarehouseEmployeeLocationFilter(UserId));
    end;
}
