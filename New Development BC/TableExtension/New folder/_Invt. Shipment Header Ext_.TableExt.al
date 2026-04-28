tableextension 80115 "Invt. Shipment Header Ext" extends "Invt. Shipment Header"
{
    fields
    {
        modify("Gen. Bus. Posting Group")
        {
            trigger OnBeforeValidate()
            begin
                IF (xRec."Gen. Bus. Posting Group" <> '') AND (Rec."Gen. Bus. Posting Group" <> '') THEN IF "Material Req. No." <> '' THEN ERROR('This document is from Material Request, Cannot change gen bus');
            end;
        }
        field(50000; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = FALSE;
        }
        field(50001; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(50002; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(50003; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(FALSE));
            CaptionClass = '1,2,3';
        }
        field(50005; "Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(FALSE));
            CaptionClass = '1,2,5';
        }
        field(50006; "Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }
}
