tableextension 80110 "Gen. Ledger Entry Ext" extends "G/L Entry"
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
        field(60100; BudgetName; Text[50])
        {
            Caption = 'Budget Name';
        }
        field(60101; BudgetCode; Text[50])
        {
            Caption = 'Budget Code';
        }
    }
}
