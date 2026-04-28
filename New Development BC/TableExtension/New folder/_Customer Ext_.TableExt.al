tableextension 80130 "Customer Ext" extends Customer
{
    fields
    {
        field(73700; "Tax Type"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = Retail,"Tax Document","Non Tax";
        }
        field(73701; "NPWP Name"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73702; "NPWP Address"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73703; "NPWP Address 2"; Text[150])
        {
            Description = 'DIS.TAX';
        }
        field(73704; "No. KTP"; Code[20])
        {
            Description = 'DIS.TAX';
        }
        field(73705; "Transaction Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "00","01","02","03","04","05","06","07","08","09";
        }
        field(73706; "Tax-Document Post"; Option)
        {
            OptionMembers = Post,Batch,Prompt;
            Description = 'DIS.TAX';
        }
        field(73707; "No. SPPKP"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(73720; "Keterangan Tambahan"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Kawasan Bebas","Tempat Penimbunan Berikat","Hibah dan Bantuan Luar Negeri",Avtur,Lainnya,"Kontraktor Perjanjian Karya Pengusahaan Pertambangan Batubara Generasi I";
        }
        field(73721; "NPWP No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(73722; "Branch Code"; Code[3])
        {
            DataClassification = ToBeClassified;
        }
    }
}
