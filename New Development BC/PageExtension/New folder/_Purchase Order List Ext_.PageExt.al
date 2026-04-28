pageextension 80132 "Purchase Order List Ext" extends "Purchase Order List"
{
    actions
    {
        addafter(Print)
        {
            action("Print Rekap PR Consignment")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRecPurchHeader: Record "Purchase Header";
                    lRecPurchLine: Record "Purchase Line";
                begin
                    Rec.TestField(Rec."No.");
                    lRecPurchLine.RESET;
                    lRecPurchLine.SETRANGE("Document Type", Rec."Document Type");
                    lRecPurchLine.SETRANGE("Document No.", Rec."No.");
                    lRecPurchLine.SETRANGE("PR Type", lRecPurchLine."PR Type"::Consignment);
                    IF NOT lRecPurchLine.FINDFIRST THEN ERROR('This purchase order doesnt have PR Line consignment in it, cannot print');
                    lRecPurchHeader.RESET;
                    lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");

                end;
            }
            action("Print Rekap Pembelian Barang")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = True;
                PromotedCategory = Process;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRecPurchHeader: Record "Purchase Header";
                    lRecPurchLine: Record "Purchase Line";
                begin
                    Rec.TestField(Rec."No.");
                    lRecPurchHeader.RESET;
                    lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");
                end;
            }
        }
    }
    var
        myInt: Integer;
}
