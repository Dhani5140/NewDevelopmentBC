tableextension 80133 "Purch. Cr. Memo Header Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50000; "Purchase Req. No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "RFQ No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Material Req. No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Shipping Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Payment Date Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "No. Surat Jalan"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Tanggal Surat Jalan"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "No. Polisi"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(73700; "NPWP Name"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73701; "NPWP Address"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73702; "NPWP Address 2"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73703; "No. KTP"; Code[20])
        {
            Description = 'DIS.TAX';
        }
        field(73704; "Tanggal Pajak"; Date)
        {
            Description = 'DIS.TAX';
        }
        field(73705; "Transaction Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "01","02","03","04","05","06","07","08","09";
        }
        field(73706; "Status Code"; Option)
        {
            OptionMembers = "0","1";
        }
        field(73707; "Tax No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(73708; Creditable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73709; Exported; Boolean)
        {
        }
        field(73710; "Exported Date"; Date)
        {
        }
        field(73711; "Actual Vendor No."; Code[20])
        {
            Caption = 'Actual Vendor No.';
            TableRelation = Vendor;
        }

    }
}
