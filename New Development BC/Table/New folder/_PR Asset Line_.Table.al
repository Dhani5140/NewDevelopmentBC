table 80110 "PR Asset Line"
{
    //Permissions = tabledata "Document Control" = rimd;
    DrillDownPageID = "PR Asset Lines";
    LookupPageID = "PR Asset Lines";

    fields
    {
        field(1; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                lRecVendor: Record Vendor;
            begin
                lRecVendor.RESET;
                lRecVendor.SETRANGE(lRecVendor."No.", "Vendor No.");
                IF lRecVendor.FINDFIRST THEN BEGIN
                    VALIDATE("VAT Bus. Posting Group", lRecVendor."VAT Bus. Posting Group");

                END
                ELSE BEGIN
                    VALIDATE("VAT Bus. Posting Group", '');

                END;
                IF "Type" = "Type"::Item THEN VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "No.", "Document Date"));
            end;
        }
        field(4; "Type"; Enum "PR Asset Line Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = filter('Item')) Item where(Type = filter(<> Inventory), Blocked = const(false))
            else
            if ("Type" = filter('Fixed Asset')) "Fixed Asset"
            else
            if ("Type" = filter('G/L Account')) "G/L Account";

            trigger OnValidate()
            var
                lRecItem: Record Item;
                lRecGL: Record "G/L Account";
                lRecFA: Record "Fixed Asset";
            begin
                if "Type" = "Type"::Item then begin
                    lRecItem.RESET;
                    lRecItem.SETRANGE(lRecItem."No.", "No.");
                    IF lRecItem.FINDFIRST THEN BEGIN
                        "Description" := lrecItem.Description;
                        VALIDATE("VAT Prod. Posting Group", lRecItem."VAT Prod. Posting Group");

                        VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "No.", "Document Date"));
                    END
                    ELSE BEGIN
                        "Description" := '';
                        VALIDATE("VAT Prod. Posting Group", '');

                        VALIDATE("Direct Unit Cost", 0);
                    END;
                end
                else
                    if "Type" = "Type"::"G/L Account" then begin
                        lRecGL.RESET;
                        lRecGL.SETRANGE(lRecGL."No.", "No.");
                        IF lRecGL.FINDFIRST THEN BEGIN
                            Rec."Description" := lRecGL.Name;
                            VALIDATE("VAT Bus. Posting Group", lRecGL."VAT Bus. Posting Group");
                            VALIDATE("VAT Prod. Posting Group", lRecGL."VAT Prod. Posting Group");


                        END
                        ELSE BEGIN
                            VALIDATE("VAT Bus. Posting Group", '');
                            VALIDATE("VAT Prod. Posting Group", '');


                        END;
                    end
                    else
                        if "Type" = "Type"::"Fixed Asset" then begin
                            lrecFA.Reset();
                            if lrecFA.GET("No.") then begin
                                "Description" := lrecFA.Description;
                            end;
                        end;
                IF "Type" = "Type"::" " then Error('You cannot choose empty');
            end;
        }
        field(6; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(7; "Part No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = if ("Type" = filter('Item')) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            if ("Type" = filter('G/L Account')) "Unit of Measure".Code
            else
            if ("Type" = filter('Fixed Asset')) "Unit of Measure".Code
            else
            if ("Type" = filter(' ')) "Unit of Measure".Code;

            trigger OnValidate()
            begin
            end;
        }
        field(9; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField(Quantity);
                IF Quantity - totalQtyonProcess() < 0 THEN ERROR('This line already has %1 in PO, cannot input below that', totalQtyonProcess());
                "Outstanding Quantity" := Quantity - totalQtyonProcess();
                VALIDATE("Qty to PO", Quantity);
                Validate("Subtotal Amount", Quantity * "Direct Unit Cost");
            end;
        }
        field(10; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(11; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate("Subtotal Amount", Quantity * "Direct Unit Cost");
            end;
        }
        field(12; "Subtotal Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
            end;
        }
        field(13; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                Validate("Discount Amount", "Discount %" / 100 * "Subtotal Amount");
            end;
        }
        field(14; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validate("Line Amount", "Subtotal Amount" - "Discount Amount");
            end;
        }
        field(15; "VAT Prod. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(16; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                calcPPN();
            end;
        }
        field(17; "VAT %"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = Lookup("VAT Posting Setup"."VAT %" where("VAT Prod. Posting Group" = field("VAT Prod. Posting Group"), "VAT Bus. Posting Group" = field("VAT Bus. Posting Group")));
        }
        field(18; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                VALIDATE("Total Amount", "Line Amount" + "VAT Amount" - "WHT Amount");
            end;
        }



        field(22; "WHT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                VALIDATE("Total Amount", "Line Amount" + "VAT Amount" - "WHT Amount");
            end;
        }
        field(23; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                calcPPN();

                VALIDATE("Total Amount", "Line Amount" + "VAT Amount" - "WHT Amount");
            end;
        }
        field(24; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Location Code"; code[50])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(27; "Created By"; code[150])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(28; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(29; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(30; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(31; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."), "Location Code" = field("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("PR Asset Header".Status WHERE("Purchase Req. No." = field("Purchase Req. No.")));
        }
        field(33; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';
        }
        field(34; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
        field(35; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(36; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';
        }
        field(37; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(38; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';
        }
        field(39; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';
        }
        field(40; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';
        }
        field(41; "Total Qty On PO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Asset)));
        }
        field(42; "Total Amount On PO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line"."Line Amount" where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Asset)));
        }
        field(43; "Total Qty on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Asset)));
        }
        field(44; "Total Amount on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line"."Line Amount" where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Asset)));
        }
        field(45; "Qty to PO"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Qty to PO" > "Outstanding Quantity" THEN ERROR('Qty to PO cannot input more than %1', "Outstanding Quantity");
            end;
        }
        field(46; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Type" = "Type"::Item THEN VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "No.", "Document Date"));
            end;
        }
        field(47; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(48; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
    }
    keys
    {
        key(PK; "Purchase Req. No.", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    var
        grecFA: Record "Fixed Asset";

    trigger OnInsert()
    var
        lRecPRHeader: Record "PR Asset Header";
    begin
        lRecPRHeader.RESET;
        lRecPRHeader.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
        IF lRecPRHeader.FINDFIRST THEN BEGIN
            Rec."Location Code" := lRecPRHeader."Location Code";
            Rec.VALIDATE("Vendor No.", lRecPRHeader."Vendor No.");
            Rec.VALIDATE("Document Date", lRecPRHeader."Document Date");
            Rec."Shortcut Dimension 1 Code" := lRecPRHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := lRecPRHeader."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension 3 Code" := lRecPRHeader."Shortcut Dimension 3 Code";
            Rec."Shortcut Dimension 4 Code" := lRecPRHeader."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension 5 Code" := lRecPRHeader."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension 6 Code" := lRecPRHeader."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 7 Code" := lRecPRHeader."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension 8 Code" := lRecPRHeader."Shortcut Dimension 8 Code";
        END;
        "Created By" := UserId;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserID;
        "Last Modified Date" := CurrentDateTime;
    end;

    trigger OnDelete()
    var
        lrecPRHeader: Record "PR Asset Header";
    begin
        lrecPRHeader.RESET();
        lrecPRHeader.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
        IF lrecPRHeader.FIND('-') then lrecPRHeader.TestField(Status, lrecPRHeader.Status::Open);
        gCUPRFunct.checkPRLinehasPO(Rec."Purchase Req. No.", Rec."Line No.", 'delete');
    end;

    procedure calcPPN()
    var
        lRecVATSetup: Record "VAT Posting Setup";
    begin
        lRecVATSetup.RESET;
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Prod. Posting Group", "VAT Prod. Posting Group");
        lRecVATSetup.SETRANGE(lRecVATSetup."VAT Bus. Posting Group", "VAT Bus. Posting Group");
        IF lRecVATSetup.FINDFIRST THEN
            VALIDATE("VAT Amount", "Line Amount" * (lRecVATSetup."VAT %") / 100)
        ELSE
            VALIDATE("VAT Amount", 0);
    end;

    procedure totalQtyonProcess(): Decimal
    var
        lRecRFQLineDet: Record "RFQ Line Details";
    begin
        Rec.CalcFields("Total Qty On PO", "Total Qty on Posted Order");
        exit(Rec."Total Qty On PO" + Rec."Total Qty on Posted Order");
    end;

    var
        gRecItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        gCUPRFunct: Codeunit "PR Asset Function";
        gCUMSIFunct: Codeunit "MII Function";
        gdecSisa: Decimal;
}
