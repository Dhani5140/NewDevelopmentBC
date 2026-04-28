tableextension 80108 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "No. Shipping"; code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "No. Berita Acara"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Material Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Material Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Purchase Req. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Purchase Req. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Line Counter Auto Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "PR Type"; Enum "PR Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "MR Usage Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "MR Usage Category".Code;
        }
        field(50009; "Unit Group"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Group Dimension";
        }
        field(73707; "Tax No."; Code[30])
        {
            Description = 'DIS.TAX';
        }
        field(50022; "WHT Business Posting Group"; Code[20])
        {
            Caption = 'WHT Business Posting Group';
            TableRelation = "WHT Buss Posting Group";
        }
        field(50023; "WHT Product Posting Group"; Code[20])
        {
            Caption = 'WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group";
        }
        field(50024; "WHT Absorb Base"; Decimal)
        {
            Caption = 'WHT Absorb Base';
        }
        field(50025; "WHT %"; Decimal)
        {
            TableRelation = "WHT Posting Setup"."WHT %";
        }
        field(50026; "Actual Vendor No."; Code[20])
        {
            Caption = 'Actual Vendor No.';
            TableRelation = Vendor;
        }
        field(28047; "WHT Payment"; Boolean)
        {
            Caption = 'WHT Payment';

            trigger OnValidate()
            begin
                ReadGLSetup();
                if not GLSetup."Manual Sales WHT Calc." then
                    "WHT Payment" := false;
            end;
        }
        field(28046; "Certificate Printed"; Boolean)
        {
            Caption = 'Certificate Printed';
        }
        field(28049; "Is WHT"; Boolean)
        {
            Caption = 'Is WHT';
        }
        field(28044; "WHT Report Line No."; Code[20])
        {
            Caption = 'WHT Report Line No.';
        }
        field(28045; "Skip WHT"; Boolean)
        {
            Caption = 'Skip WHT';
        }
        field(60100; BudgetName; Text[50])
        {
            Caption = 'Budget Name';
        }
        field(60101; BudgetCode; Text[50])
        {
            Caption = 'Budget Code';
        }
    }
    var
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";

    local procedure ReadGLSetup()
    begin
        if not GLSetupRead then begin
            GLSetup.Get();
            GLSetupRead := true;
        end;
    end;

}
