pageextension 80102 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Location Code")
        {
            field("Receiving No. Series"; Rec."Receiving No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("Status")
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = all;
            }

            field("Purchase Req. No."; Rec."Purchase Req. No.")
            {
                ApplicationArea = all;
            }

            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = all;
            }
            // field("No. Polisi"; Rec."No. Polisi")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Surat Jalan"; Rec."No. Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Shipment Method Code")
        {
            // field("Shipping Date"; Rec."Shipping Date")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Surat Jalan"; Rec."No. Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("Tanggal Surat Jalan"; Rec."Tanggal Surat Jalan")
            // {
            //     ApplicationArea = All;
            // }
            // field("No. Polisi"; Rec."No. Polisi")
            // {
            //     ApplicationArea = All;
            // }
        }
        addafter("Payment Method Code")
        {
            field("Payment Date"; Rec."Payment Date")
            {
                ApplicationArea = All;
            }
            field("Payment Date Description"; Rec."Payment Date Description")
            {
                ApplicationArea = All;
            }
        }
        addafter(PurchLines)
        {
            group("Tax Module")
            {
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("NPWP Name"; Rec."NPWP Name")
                {
                    ApplicationArea = All;
                }
                field("NPWP Address"; Rec."NPWP Address")
                {
                    ApplicationArea = All;
                }
                field(Creditable; Rec.Creditable)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter(Warehouse)
        {
            // action("Print Rekap PR Consignment")
            // {
            //     ApplicationArea = All;
            //     Image = Print;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     PromotedIsBig = TRUE;

            //     trigger OnAction()
            //     var
            //         lRecPurchHeader: Record "Purchase Header";
            //         lRecPurchLine: Record "Purchase Line";
            //     begin
            //         Rec.TestField(Rec."No.");
            //         lRecPurchLine.RESET;
            //         lRecPurchLine.SETRANGE("Document Type", Rec."Document Type");
            //         lRecPurchLine.SETRANGE("Document No.", Rec."No.");
            //         lRecPurchLine.SETRANGE("PR Type", lRecPurchLine."PR Type"::Consignment);
            //         IF NOT lRecPurchLine.FINDFIRST THEN ERROR('This purchase order doesnt have PR Line consignment in it, cannot print');
            //         lRecPurchHeader.RESET;
            //         lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");

            //     end;
            // }
            // action("Print Rekap Pembelian Barang")
            // {
            //     ApplicationArea = All;
            //     Image = Print;
            //     Promoted = True;
            //     PromotedCategory = Process;
            //     PromotedIsBig = TRUE;

            //     trigger OnAction()
            //     var
            //         lRecPurchHeader: Record "Purchase Header";
            //         lRecPurchLine: Record "Purchase Line";
            //     begin
            //         Rec.TestField(Rec."No.");
            //         lRecPurchHeader.RESET;
            //         lRecPurchHeader.SETRANGE(lRecPurchHeader."No.", Rec."No.");

            //     end;
            // }

            group("Document Tracking")
            {

                Image = OrderTracking;
                action("Material Request")
                {
                    ApplicationArea = all;
                    Caption = 'Material Request Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    VAR
                        mr: Record "Material Req. Line";

                    begin
                        mr.SetRange("Material Req. No.", Rec."Material Req. No.");
                        page.run(PAGE::"Material Request Lines", mr);
                    end;
                }
                action("Purchase Request")
                {
                    ApplicationArea = all;
                    Caption = 'Purchase Request Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    VAR
                        mr: Record "PR Material Line";

                    begin
                        mr.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                        page.run(PAGE::"PR Material Lines", mr);
                    end;
                }
                action("RFQ DOC")
                {
                    ApplicationArea = all;
                    Caption = 'RFQ Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    VAR
                        mr: Record "RFQ Line";
                    begin
                        mr.SetRange("Purchase Req. No.", rec."Purchase Req. No.");
                        page.run(PAGE::"RFQ Request Lines", mr);
                    end;
                }

                action("Vensel DOC")
                {
                    ApplicationArea = all;
                    Caption = 'Vendor selection Document';
                    Image = OrderTracking;
                    trigger OnAction()
                    VAR
                        mr: Record "RFQ Line";
                    begin
                        mr.SetRange("Purchase Req. No.", rec."Purchase Req. No.");
                        page.run(PAGE::"vensel Request Lines", mr);
                    end;
                }

            }
        }
        addlast(processing)
        {

        }
    }

}
