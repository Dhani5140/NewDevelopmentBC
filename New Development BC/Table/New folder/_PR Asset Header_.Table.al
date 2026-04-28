table 80109 "PR Asset Header"
{
    Caption = 'PR Asset Header';
    DataCaptionFields = "Purchase Req. No.";
    LookupPageID = "PR Asset List";
    DrillDownPageId = "PR Asset List";

    fields
    {
        field(1; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lRecMSISetup: Record "MII Setup";
            begin
                lRecMSISetup.GET();
                IF "Purchase Req. No." <> xRec."Purchase Req. No." THEN BEGIN
                    NoSeries.TestManual(lRecMSISetup."PR Asset Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = ToBeClassified;
        }
        field(3; "User ID"; code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; RequesterID; Code[20])
        {
            Caption = 'RequesterID';
            DataClassification = ToBeClassified;
            TableRelation = "Employee";

            trigger OnValidate()
            var
                lRecEmployee: Record Employee;
            begin
                lRecEmployee.RESET;
                lRecEmployee.GET("RequesterID");
                "Requester Name" := lRecEmployee.FullName();
            end;
        }
        field(5; "Requester Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7; "Status"; Enum "PR Module Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                lCUPRFunct: Codeunit "PR Asset Function";
            begin
                Case Status OF
                    Status::Open:
                        BEGIN
                            IF xRec.Status <> xRec.Status::Open THEN BEGIN
                                lCUPRFunct.checkPRLinehasPO(Rec."Purchase Req. No.", 0, 'reopen');
                            END;
                        END;
                End;
            end;
        }
        field(8; "Created By"; code[250])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(9; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = ToBeClassified;
        }
        field(10; "Last Modified By"; code[250])
        {
            Caption = 'Last Modified By';
            DataClassification = ToBeClassified;
        }
        field(11; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified Date';
            DataClassification = ToBeClassified;
        }
        field(12; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            FieldClass = FlowField;
            CalcFormula = sum("PR Asset Line"."Total Amount" where("Purchase Req. No." = field("Purchase Req. No.")));
        }
        field(13; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Location";

            trigger OnValidate()
            var
                lrecPRLine: Record "PR Asset Line";
                LabelConfirm: Label 'This will change "Location Code" in all line, do you want to continue?';
            begin
                lrecPRLine.RESET();
                lrecPRLine.SetRange("Purchase Req. No.", Rec."Purchase Req. No.");
                IF lrecPRLine.FIND('-') then // IF Confirm(LabelConfirm) THEN BEGIN
                    updateDocLines(FieldNo("Location Code"));
                // END;
            END;
        }
        field(14; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(FALSE));
            CaptionClass = '1,2,1';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 1 Code"));
            end;
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(FALSE));
            CaptionClass = '1,2,2';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 2 Code"));
            end;
        }
        field(18; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 3 Code"));
            end;
        }
        field(19; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(FALSE));
            CaptionClass = '1,2,4';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 4 Code"));
            end;
        }
        field(20; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 5 Code"));
            end;
        }
        field(21; "Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(FALSE));
            CaptionClass = '1,2,6';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 6 Code"));
            end;
        }
        field(22; "Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(FALSE));
            CaptionClass = '1,2,7';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 7 Code"));
            end;
        }
        field(23; "Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(FALSE));
            CaptionClass = '1,2,8';

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Shortcut Dimension 8 Code"));
            end;
        }
        field(24; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Blocked = const(" "));

            trigger OnValidate()
            var
                lrecVendor: Record Vendor;
            begin
                lrecVendor.RESET;
                if lrecVendor.GET("Vendor No.") then begin
                    "Vendor Name" := lrecVendor.Name;
                    VALIDATE("Payment Terms Code", lrecVendor."Payment Terms Code");
                end
                else begin
                    "Vendor Name" := '';
                    VALIDATE("Payment Terms Code", '');
                end;
                UpdateDocLines(FieldNo("Vendor No."));
            end;
        }
        field(25; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                lRec: Record "Payment Terms";
            begin
                lRec.RESET;
                lRec.SETRANGE(lRec.Code, Rec."Payment Terms Code");
                IF lRec.FINDFIRST THEN BEGIN
                    "Payment Terms Name" := lRec.Description;
                END
                ELSE BEGIN
                    "Payment Terms Name" := '';
                END;
            end;
        }
        field(27; "Payment Terms Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Batch No. [PR]"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Urgent Status"; Enum "PR Urgent Status")
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Document Date"));
            end;
        }
        field(31; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("MR Usage Category"));
            end;
        }
        field(32; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";

            trigger OnValidate()
            begin
                UpdateDocLines(FieldNo("Unit Group"));
            end;
        }
    }
    keys
    {
        key(PK; "Purchase Req. No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        lrecPurchaseReqLine: Record "PR Asset Line";
    begin
        TestField("Status", "Status"::Open);
        lrecPurchaseReqLine.RESET();
        lrecPurchaseReqLine.SETRANGE("Purchase Req. No.", Rec."Purchase Req. No.");
        IF lrecPurchaseReqLine.Find('-') THEN BEGIN
            lrecPurchaseReqLine.DELETEALL(TRUE)
        END
    end;

    trigger OnInsert()
    var
        lRecMSISetup: Record "MII Setup";
    begin
        if "Purchase Req. No." = '' then begin
            lRecMSISetup.reset();
            IF lRecMSISetup.GET() then begin
                lRecMSISetup.TestField("PR Asset Nos.");
            end;
            //NoSeriesMgt.InitSeries(lRecMSISetup."PR Asset Nos.", xRec."No. Series", 0D, "Purchase Req. No.", "No. Series");
            NoSeries.AreRelated(lRecMSISetup."PR Asset Nos.", xRec."No. Series");
        end;
        "User ID" := USERID;
        "Urgent Status" := "Urgent Status"::High;
        VALIDATE("Document Date", WORKDATE);
        "Request Date" := WORKDATE;
        "Created By" := USERID;
        "Created Date" := CurrentDateTime;
        "Last Modified By" := USERID;
        "Last Modified Date" := CurrentDateTime;
        Status := Status::Open;
    end;

    trigger OnRename()
    begin
        ERROR(Text003, TABLECAPTION);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;
    end;

    procedure AssistEdit(): Boolean
    var
        lRecMSISetup: Record "MII Setup";
    begin
        lRecMSISetup.GET;
        lRecMSISetup.TESTFIELD("PR Asset Nos.");
        // IF NoSeriesMgt.SelectSeries(lRecMSISetup."PR Asset Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
        //     NoSeriesMgt.SetSeries(Rec."Purchase Req. No.");
        IF NoSeries.LookupRelatedNoSeries(lRecMSISetup."PR Asset Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
            NoSeries.GetNextNo(Rec."Purchase Req. No.");
            EXIT(TRUE);
        END;
    end;

    procedure updateDocLines(FieldRef: Integer)
    var
        lRecPRLine: Record "PR Asset Line";
    begin
        lRecPRLine.RESET;
        lRecPRLine.SETRANGE("Purchase Req. No.", "Purchase Req. No.");
        IF lRecPRLine.FIND('-') THEN BEGIN
            REPEAT
                case FieldRef of
                    FieldNo("Shortcut Dimension 1 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    FieldNo("Shortcut Dimension 2 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    FieldNo("Shortcut Dimension 3 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code");
                    FieldNo("Shortcut Dimension 4 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 4 Code", "Shortcut Dimension 4 Code");
                    FieldNo("Shortcut Dimension 5 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 5 Code", "Shortcut Dimension 5 Code");
                    FieldNo("Shortcut Dimension 6 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 6 Code", "Shortcut Dimension 6 Code");
                    FieldNo("Shortcut Dimension 7 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 7 Code", "Shortcut Dimension 7 Code");
                    FieldNo("Shortcut Dimension 8 Code"):
                        lRecPRLine.VALIDATE("Shortcut Dimension 8 Code", "Shortcut Dimension 8 Code");
                    FieldNo("Vendor No."):
                        lRecPRLine.VALIDATE("Vendor No.", "Vendor No.");
                    FieldNo("Location Code"):
                        lRecPRLine.VALIDATE("Location Code", "Location Code");
                    FieldNo("Document Date"):
                        lRecPRLine.VALIDATE("Document Date", "Document Date");
                end;
                lRecPRLine.MODIFY(TRUE);
            UNTIL lRecPRLine.NEXT = 0;
        END;
    end;

    var
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        Text003: Label 'You cannot rename a %1.';
}
