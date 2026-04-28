tableextension 80107 "Sales Inv. Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                lrecCustomer: Record "Customer";
            begin
                lrecCustomer.RESET();
                IF lrecCustomer.GET(Rec."Sell-to Customer No.") THEN BEGIN
                    Rec."NPWP Name" := lrecCustomer."NPWP Name";
                    Rec."NPWP Address" := lrecCustomer."NPWP Address";
                    Rec."NPWP Address 2" := lrecCustomer."NPWP Address 2";
                    Rec."Transaction Code" := lrecCustomer."Transaction Code";
                    Rec."Tax Type" := lrecCustomer."Tax Type";
                    Rec."No. SPPKP" := lrecCustomer."No. SPPKP";
                    IF lrecCustomer."Tax-Document Post" = lrecCustomer."Tax-Document Post"::Post THEN Rec."Tax-Document Post" := Rec."Tax-Document Post"::Post;
                    IF lrecCustomer."Tax-Document Post" = lrecCustomer."Tax-Document Post"::Batch THEN Rec."Tax-Document Post" := Rec."Tax-Document Post"::Batch;
                    IF lrecCustomer."Tax-Document Post" = lrecCustomer."Tax-Document Post"::Prompt THEN Rec."Tax-Document Post" := Rec."Tax-Document Post"::Prompt;
                    //Rec.MODIFY();
                END;
            end;
        }
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
        field(73718; "Amount PPNBM"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalculatePPNBM();
            end;
        }
        modify("Amount Including VAT")
        {
            trigger OnAfterValidate()
            begin
                CalculatePPNBM();
            end;
        }
        modify(Amount)
        {
            trigger OnAfterValidate()
            begin
                CalculatePPNBM();
            end;
        }
    }
    var
        myInt: Integer;

    // trigger OnModify()
    // begin
    //     Message('OnModify Triggered');
    //     CalculatePPNBM();
    // end;

    // trigger OnInsert()
    // begin
    //     Message('OnInsert Triggered');
    //     CalculatePPNBM();
    // end;

    procedure CalculatePPNBM()
    begin
        // Message('CalculatePPNBM Triggered! Amount: %1, Amount Including VAT: %2', Amount, "Amount Including VAT");
        // if ("Amount Including VAT" > 0) and (Amount > 0) then
        //     "Amount PPNBM" := "Amount Including VAT" - Amount
        // else
        //     "Amount PPNBM" := 0;

        // Message('New Amount PPNBM: %1', "Amount PPNBM");
        // Modify(); // Simpan hasil perhitungan
    end;

}
