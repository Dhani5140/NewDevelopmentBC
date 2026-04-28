pageextension 70150 invtship extends "Posted Invt. Shipment Subform"
{
    layout
    {

    }
    actions
    {
        addlast("&Line")
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