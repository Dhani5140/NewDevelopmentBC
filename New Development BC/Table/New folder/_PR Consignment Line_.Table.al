table 80118 "PR Consignment Line"
{
    //Permissions = tabledata "Document Control" = rimd;
    DrillDownPageID = "PR Consignment Lines";
    LookupPageID = "PR Consignment Lines";

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
        field(3; "Item No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
            TableRelation = Item."No." where(Type = const(Inventory), Blocked = const(false));

            trigger OnValidate()
            var
                lrecItem: Record Item;
                lrecCOA: Record "G/L Account";
            begin
                Rec.TestField("Item No.");
                IF xRec."Item No." <> Rec."Item No." THEN BEGIN
                    IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                        ERROR('This line is from Material Request, Cannot change item no');
                    END;
                END;
                lrecItem.RESET;
                lrecItem.GET("Item No.");
                lrecItem.TESTFIELD(Blocked, FALSE);
                lrecItem.TESTFIELD("Gen. Prod. Posting Group");
                IF lrecItem.Type = lrecItem.Type::Inventory THEN BEGIN
                    lrecItem.TESTFIELD("Inventory Posting Group");
                END;
                Rec.Description := lrecItem.Description;
                Rec."Unit of Measure" := lrecItem."Purch. Unit of Measure";
                VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
                Rec."PPH 22" := lRecItem."PPH 22";
                VALIDATE("Gen. Prod Posting Group", lrecItem."Gen. Prod. Posting Group");
            end;
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = FIeld("Item No."));

            trigger OnValidate()
            begin
            end;
        }
        field(6; "Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField(Quantity);
                IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
                    IF xRec.Quantity <> Rec.Quantity THEN BEGIN
                        gRecMRLine.RESET;
                        gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
                        gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
                        IF gRecMRLine.FINDFIRST THEN BEGIN
                            IF gRecMRLine."Outstanding Quantity" + (xRec.Quantity - Rec.Quantity) < 0 THEN ERROR('You cannot input more than %1', gRecMRLine."Outstanding Quantity" + xRec.Quantity);
                            gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, Quantity);
                        END;
                    END;
                END;
                "Outstanding Quantity" := Quantity;
                "Line Amount" := Quantity * "Direct Unit Cost";
            end;
        }
        field(7; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(8; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Line Amount" := "Quantity" * "Direct Unit Cost";
            end;
        }
        field(9; "Line Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Created By"; code[150])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(11; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(12; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(13; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(14; "Brand"; code[150])
        {
            Caption = 'Brand';
            DataClassification = ToBeClassified;
        }
        field(15; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Location Code"; code[50])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(17; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Original Qty MR"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."), "Location Code" = field("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Status; Enum "PR Module Status")
        {
            Caption = 'Status';
            FieldClass = FlowField;
            CalcFormula = lookup("PR Consignment Header".Status WHERE("Purchase Req. No." = field("Purchase Req. No.")));
        }
        field(22; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            begin
                VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, "Shortcut Dimension 3 Code"));
            end;
        }
        field(23; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';
        }
        field(24; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';

            trigger OnValidate()
            begin
                VALIDATE("Unit Group", gCUMSIFunct.getUnitGroupDimension(3, "Shortcut Dimension 3 Code"));
            end;
        }
        field(25; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';
        }
        field(26; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(27; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';
        }
        field(28; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';
        }
        field(29; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';
        }
        field(30; "PPH 22"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Total Qty On PO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Consignment)));
        }
        field(32; "Total Amount On PO"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Purchase Line"."Line Amount" where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Consignment)));
        }
        field(33; "Total Qty on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Consignment)));
        }
        field(34; "Total Amount on Posted Order"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("Purch. Inv. Line"."Line Amount" where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "PR Type" = const(Consignment)));
        }
        field(35; "BPB No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(37; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(38; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            begin
                VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
            end;
        }
        field(39; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                VALIDATE("Direct Unit Cost", gCUMSIFunct.getPurchPrice("Vendor No.", "Item No.", "Document Date"));
            end;
        }
        field(40; "Gen. Prod Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(41; "Total Qty On Gen. Journal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = SUM("Gen. Journal Line".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "Line Counter Auto Journal" = const(FALSE), "PR Type" = const(Consignment)));
        }
        field(42; "Total Qty on G/L Entry"; Decimal)
        {
            FieldClass = FlowField;
            Editable = FALSE;
            CalcFormula = SUM("G/L Entry".Quantity where("Purchase Req. No." = FIELD("Purchase Req. No."), "Purchase Req. Line No." = FIELD("Line No."), "Line Counter Auto Journal" = const(FALSE), "PR Type" = const(Consignment)));
        }
        field(43; "Gen Bus. Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(44; "Cancel"; Boolean)
        {
            DataClassification = ToBeClassified;
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
        lRecPRHeader: Record "PR Consignment Header";
    begin
        lRecPRHeader.RESET;
        lRecPRHeader.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
        IF lRecPRHeader.FINDFIRST THEN BEGIN
            Rec."Location Code" := lRecPRHeader."Location Code";
            Rec."Shortcut Dimension 1 Code" := lRecPRHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := lRecPRHeader."Shortcut Dimension 2 Code";
            Rec."Shortcut Dimension 3 Code" := lRecPRHeader."Shortcut Dimension 3 Code";
            Rec."Shortcut Dimension 4 Code" := lRecPRHeader."Shortcut Dimension 4 Code";
            Rec."Shortcut Dimension 5 Code" := lRecPRHeader."Shortcut Dimension 5 Code";
            Rec."Shortcut Dimension 6 Code" := lRecPRHeader."Shortcut Dimension 6 Code";
            Rec."Shortcut Dimension 7 Code" := lRecPRHeader."Shortcut Dimension 7 Code";
            Rec."Shortcut Dimension 8 Code" := lRecPRHeader."Shortcut Dimension 8 Code";
            Rec."MR Usage Category" := lRecPRHeader."MR Usage Category";
            Rec."Unit Group" := lRecPRHeader."Unit Group";
            Rec.VALIDATE("Vendor No.", lRecPRHeader."Vendor No.");
            Rec.VALIDATE("Document Date", lRecPRHeader."Document Date");
            Rec.VALIDATE("Gen Bus. Posting Group", lRecPRHeader."Gen Bus. Posting Group");
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
        lrecMRLine: Record "MR Consignment Line";
        lrecPRHeader: Record "PR Consignment Header";
    begin
        lrecPRHeader.RESET();
        lrecPRHeader.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
        IF lrecPRHeader.FIND('-') then lrecPRHeader.TestField(Status, lrecPRHeader.Status::Open);
        IF Rec."BPB No." <> '' THEN IF Rec.Cancel = FALSE THEN ERROR('PR line already has BPB No %1, cannot delete', Rec."BPB No.");

        IF ("Material Req. No." <> '') AND ("Material Req. Line No." <> 0) THEN BEGIN
            gRecMRLine.RESET;
            gRecMRLine.SETRANGE("Material Req. No.", "Material Req. No.");
            gRecMRLine.SETRANGE("Line No.", "Material Req. Line No.");
            IF gRecMRLine.FINDFIRST THEN BEGIN
                gCUMRFunct.updOutstandingQtyMR(gRecMRLine, Rec.RecordID, 0);
            END;
        END;
    end;

    var
        gRecMRLine: Record "MR Consignment Line";
        gRecItem: Record Item;
        UOMMgt: Codeunit "Unit of Measure Management";
        gCUMRFunct: Codeunit "MR Consignment Function";

        gCUMSIFunct: Codeunit "MII Function";
        gdecSisa: Decimal;
}
