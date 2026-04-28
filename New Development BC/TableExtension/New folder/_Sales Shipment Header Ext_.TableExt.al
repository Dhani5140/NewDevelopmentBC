tableextension 80132 "Sales Shipment Header Ext" extends "Sales Shipment Header"
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
        field(73700; "Tax Type"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = Retail,"Tax Document"," Non Tax";
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
            OptionMembers = "01","02","03","04","05","06","07","08","09";
        }
        field(73706; "Status Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "0","1";
        }
        field(73707; "Tax No."; Code[30])
        {
            Description = 'DIS.TAX';
        }
        field(73708; "Tax-Document Post"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = Post,Batch,Prompt;
        }
        field(73720; "Keterangan Tambahan"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Kawasan Bebas","Tempat Penimbunan Berikat","Hibah dan Bantuan Luar Negeri",Avtur,Lainnya,"Kontraktor Perjanjian Karya Pengusahaan Pertambangan Batubara Generasi I";
        }
        field(73717; "No. SPPKP"; code[30])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        myInt: Integer;
}
