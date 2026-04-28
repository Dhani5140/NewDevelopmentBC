page 70151 "InvtNewShipment"
{
    Editable = false;
    PageType = List;
    SourceTable = "Invt. Shipment Line";


    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                ShowCaption = false;

                field("Material Req. No."; Rec."Material Req. No.")
                {
                    ApplicationArea = all;
                    Visible = true;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Visible = true;
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = all;
                    Visible = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Visible = true;
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {
            action("Show Document")
            {
                ApplicationArea = all;
                Caption = 'Show Document';
                Image = View;

                trigger OnAction()
                var
                    lRecPRHeader: Record "Invt. Shipment Header";
                    pagemanagement: Codeunit "Page Management";
                begin
                    lRecPRHeader.get(rec."Document No.");
                    page.Run(page::"Posted Invt. Shipment", lRecPRHeader);
                end;
            }
        }
    }
}
