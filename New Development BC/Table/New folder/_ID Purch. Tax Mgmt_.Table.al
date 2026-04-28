table 80120 "ID Purch. Tax Mgmt"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            CaptionML = ENU = 'Document Type', ENA = 'Document Type';
            OptionCaptionML = ENU = 'Invoice,Credit Memo,Return Order', ENA = 'Invoice,CR/Adj Note,Return Order';
            OptionMembers = Invoice,"Credit Memo";
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Pay-to Vendor No."; code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(5; "Pay-to Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Pay to Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Pay-to Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Pay-to Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Pay-to City"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
        }
        field(10; "Pay-to Contact"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Your Reference"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Ship-to Code"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(13; "Ship-to Name"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Ship-to Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Ship-to Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Ship-to Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Ship-to City"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
        }
        field(18; "Ship-to Contact"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Order Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Expected Receipt Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Posting Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Payment Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Vendor Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Language Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(44; "Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
        }
        field(46; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = CONST("Posted Invoice"), "No." = FIELD("No."), "Document Line No." = CONST(0)));
        }
        field(47; "No. Printed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "On Hold"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Bal. Account No."; code[20])
        {
            DataClassification = ToBeClassified;
            tableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(60; Amount; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line".Amount WHERE("Document No." = FIELD("No.")));
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
        }
        field(66; "Vendor Order No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Vendor Invoice No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "VAT Registration No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Buy-from Vendor Name 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Buy-from Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(82; "Buy-from Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(83; "Buy-from City"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code".City;
        }
        field(84; "Buy-from Contact"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(86; "Pay-to County"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '5,1,' + "Pay-to Country/Region Code";
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(89; "Buy-from County"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '5,1,' + "Buy-from Country/Region Code";
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(92; "Ship-to County"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account","Bank Account";
        }
        field(99; "Decument Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(104; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(112; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(113; "Source Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tax Area";
        }
        field(140; "Prepayment Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(141; "Prepayment Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(151; "Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";
        }
        field(1303; "Remaining Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Vendor Ledger Entry No.")));
        }
        field(1304; "Vendor Ledger Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Ledger Entry"."Entry No.";
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purch. Inv. Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No.")));
        }
        field(1310; Cancelled; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Cancelled Document" WHERE("Source ID" = CONST(122), "Cancelled Doc. No." = FIELD("No.")));
        }
        field(1311; Corrective; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Cancelled Document" WHERE("Source ID" = CONST(124), "Cancelled By Doc. No." = FIELD("No.")));
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            dataclassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Contact;
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
        field(73711; Pick; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73712; "Amount Invoice"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line".Amount WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73713; "Amount Credit Memo"; Decimal)
        {
            CalcFormula = Sum("Purch. Cr. Memo Line".Amount WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73714; "Amount Incl. VAT Invoice"; Decimal)
        {
            CalcFormula = Sum("Purch. Inv. Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73715; "Amount Incl. VAT Credit Memo"; Decimal)
        {
            CalcFormula = Sum("Purch. Cr. Memo Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(73716; "Additional Document No"; Code[20])
        {

            //FieldClass = FlowField;
        }
        field(73717; "Additional Notes"; Text[150])
        {

            DataClassification = ToBeClassified;
        }
        field(73718; "Pick Date"; Date)
        {

            DataClassification = ToBeClassified;
        }
        field(73719; "Document No"; Code[20])
        {

            //FieldClass = FlowField;
        }
        field(73720; "Faktur Date"; Date)
        {

            //FieldClass = FlowField;
        }
        field(73721; "Faktur Pajak No"; Date)
        {

            //FieldClass = FlowField;
        }
        field(73722; "Tahun Pajak"; Decimal)
        {

            DataClassification = ToBeClassified;
        }
        field(73723; "Vendor Name"; Text[100])
        {

            //FieldClass = FlowField;
        }

        field(73724; "Amount Prepayment DPP"; Decimal)
        {

            DataClassification = ToBeClassified;
        }

        field(73725; "Amount Prepayment PPN"; Decimal)
        {

            DataClassification = ToBeClassified;
        }

        field(73726; "Amount Prepayment PPNBM"; Decimal)
        {

            DataClassification = ToBeClassified;
        }
        field(73727; "Validasi"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73728; "Line Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(73729; "NPWP No.1"; code[30])
        {
            CalcFormula = lookup(Vendor."NPWP NO." WHERE("No." = field("Buy-from Vendor No.")));
            FieldClass = FlowField;
        }
        field(73730; "NPWP Name1"; text[150])
        {
            CalcFormula = lookup(Vendor."NPWP Name" where("No." = field("Buy-from Vendor No.")));
            FieldClass = FlowField;
        }
        field(73731; "NPWP Address1"; text[150])
        {
            CalcFormula = lookup(Vendor."NPWP Address" where("No." = field("Buy-from Vendor No.")));
            FieldClass = FlowField;

        }
        field(73732; "NPWP Address21"; text[150])
        {
            CalcFormula = lookup(Vendor."NPWP Address 2" where("No." = field("Buy-from Vendor No.")));
            FieldClass = FlowField;
        }




    }
    keys
    {
        key(PK; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin
        // if "Line Number" = 0 then begin
        //     "Line Number" := GetNextLineNumber(); // Panggil fungsi untuk mendapatkan nomor urut berikutnya
        // end;
    end;

    trigger OnModify()
    begin
        if (Rec.Pick) and (Rec."Pick Date" = 0D) then begin
            Rec."Pick Date" := TODAY; // Mengisi Pick Date dengan tanggal hari ini
            Modify; // Simpan perubahan pick
        end else if not Rec.Pick then begin
            Rec."Pick Date" := 0D;
            Modify; // Simpan perubahan pick
        end;
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;

    //     local procedure GetNextLineNumber(): Integer
    //     var
    //         PurchTaxRecord: Record "ID Purch. Tax Mgmt";
    //     begin
    //         // Menghitung jumlah record yang sudah ada untuk memastikan nomor urut berurutan
    //         PurchTaxRecord.RESET();
    //         PurchTaxRecord.SETRANGE("Document Type", Rec."Document Type");

    //         // Hitung jumlah record saat ini
    //         if PurchTaxRecord.COUNT > 0 then
    //             exit(PurchTaxRecord.COUNT + 1)
    //         else
    //             exit(1); // Jika ini record pertama, mulai dari 1
    //     end;
}