pageextension 80103 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF (xRec.Quantity <> Rec.Quantity) AND (Rec."Document Type" = Rec."Document Type"::Order) THEN BEGIN
                    IF Rec."Auto Insert from Line No" <> 0 THEN ERROR('This line is auto create from system, cannot modify');
                    IF (Rec."Purchase Req. No." <> '') AND (Rec."Purchase Req. Line No." <> 0) THEN BEGIN
                        CASE Rec."PR Type" OF
                            "PR Type"::Material:
                                BEGIN
                                    IF (Rec."RFQ No." <> '') AND (Rec."RFQ Line No." <> 0) THEN BEGIN
                                        gRecRFQLine.RESET;
                                        gRecRFQLine.SETRANGE("RFQ No.", Rec."RFQ No.");
                                        gRecRFQLine.SETRANGE("Line No.", Rec."RFQ Line No.");
                                        IF gRecRFQLine.FINDFIRST THEN BEGIN
                                            IF gRecRFQLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecRFQLine."Outstanding Quantity" + xRec.Quantity);
                                            gCURFQFunct.updOutstandingQtyRFQ(gRecRFQLine, Rec.RecordID, Rec.Quantity, FALSE);
                                        END;


                                    END;
                                END;
                            "PR Type"::Asset:
                                BEGIN
                                    gRecPRAssetLine.RESET;
                                    gRecPRAssetLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
                                    gRecPRAssetLine.SETRANGE("Line No.", Rec."Purchase Req. Line No.");
                                    IF gRecPRAssetLine.FINDFIRST THEN BEGIN
                                        IF gRecPRAssetLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecPRAssetLine."Outstanding Quantity" + xRec.Quantity);
                                        gCUPRAssetFunct.updOutstandingQtyPR(gRecPRAssetLine, Rec.RecordID, Rec.Quantity, FALSE);
                                    END;
                                END;
                            "PR Type"::Consignment:
                                BEGIN
                                    ERROR('This line is from PR Consignment, cannot modify');
                                    gRecPRConsLine.RESET;
                                    gRecPRConsLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
                                    gRecPRConsLine.SETRANGE("Line No.", Rec."Purchase Req. Line No.");
                                    IF gRecPRConsLine.FINDFIRST THEN BEGIN
                                        IF gRecPRConsLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecPRConsLine."Outstanding Quantity" + xRec.Quantity);

                                    END;
                                END;
                        END;
                    END;
                END;
                CurrPage.Update();
            end;
        }
        addafter(Quantity)
        {

            field("Fixed Asset PR Qty"; Rec."Fixed Asset PR Qty")
            {
                ApplicationArea = All;
                Editable = FALSE;

                trigger OnDrillDown()
                var
                    lPage: Page "PR Asset FA List";
                begin
                    IF (Rec."PR Type" = Rec."PR Type"::Asset) AND (Rec."Purchase Req. No." <> '') THEN BEGIN
                        gRecMSISetup.GET();
                        IF (Rec."PR Line Type" = Rec."PR Line Type"::"Fixed Asset") AND ((Rec."Type" = Rec."Type"::"G/L Account") AND (Rec."No." = gRecMSISetup."No. G/L FA")) THEN BEGIN
                            CLEAR(lPage);
                            lPage.setDocNo(Rec."Document No.", Rec."Line No.", Rec."Purchase Req. No.", Rec."Purchase Req. Line No.", Rec.Quantity, Rec."Line Amount");
                            lPage.RUNMODAL();
                        END
                        ELSE BEGIN
                            ERROR('Requirement to access this page is not fulfilled');
                        END;
                    END
                    ELSE BEGIN
                        ERROR('This line is not from PR Asset, cannot access');
                    END;
                    CurrPage.UPDATE;
                end;
            }
        }
        addafter("Line Amount")
        {
            // field("WHT Code"; rec."WHT Code")
            // {
            //     ApplicationArea = all;
            // }
            field("WHT Business Posting Group"; rec."WHT Business Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT Product Posting Group"; rec."WHT Product Posting Group")
            {
                ApplicationArea = all;
            }
            field("WHT %"; rec."WHT %")
            {
                ApplicationArea = all;
            }

            field("Prepayment VAT Identifier"; Rec."Prepayment VAT Identifier")
            {
                ApplicationArea = all;
                Editable = true;
            }
            // field("WHT Absorb Base"; rec."WHT Absorb Base")
            // {
            //     ApplicationArea = all;
            // }
            field("GL Budget Name"; Rec."GL Budget Name")
            {
                ApplicationArea = All;
            }

            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
            field("GL Available Budget"; Rec."GL Available Budget")
            {
                ApplicationArea = All;
            }
            field("GL Budgeted Amount"; Rec."GL Budgeted Amount")
            {
                ApplicationArea = All;
            }
            field("Fixed Asset PR Amount"; Rec."Fixed Asset PR Amount")
            {
                ApplicationArea = All;
                Editable = FALSE;

                trigger OnDrillDown()
                var
                    lPage: Page "PR Asset FA List";
                begin
                    IF (Rec."PR Type" = Rec."PR Type"::Asset) AND (Rec."Purchase Req. No." <> '') THEN BEGIN
                        gRecMSISetup.GET();
                        IF (Rec."PR Line Type" = Rec."PR Line Type"::"Fixed Asset") AND ((Rec."Type" = Rec."Type"::"G/L Account") AND (Rec."No." = gRecMSISetup."No. G/L FA")) THEN BEGIN
                            CLEAR(lPage);
                            lPage.setDocNo(Rec."Document No.", Rec."Line No.", Rec."Purchase Req. No.", Rec."Purchase Req. Line No.", Rec.Quantity, Rec."Line Amount");
                            lPage.RUNMODAL();
                        END
                        ELSE BEGIN
                            ERROR('Requirement to access this page is not fulfilled');
                        END;
                    END
                    ELSE BEGIN
                        ERROR('This line is not from PR Asset, cannot access');
                    END;
                    CurrPage.UPDATE;
                end;
            }
        }
        moveafter("Bin Code"; Quantity)

        addafter(AmountBeforeDiscount)
        {
            // field("WHT Product Posting Group"; "WHT Product Posting Group")
            // {

            // }
        }
    }
    actions
    {
        addlast(processing)
        {
        }
    }
    var
        gRecRFQLine: Record "RFQ Line";
        gRecMSISetup: Record "MII Setup";
        gRecPRAssetLine: Record "PR Asset Line";
        gRecPRConsLine: Record "PR Consignment Line";
        gCURFQFunct: Codeunit "RFQ Function";
        gCUPRAssetFunct: Codeunit "PR Asset Function";

    trigger OnAfterGetRecord()
    begin

    end;
}
