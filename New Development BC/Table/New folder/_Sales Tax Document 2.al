table 80223 "ID Sales Tax Mgmt1"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,"Credit Memo";
        }

        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }

        field(3; "No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Document Type" = CONST(Invoice)) "Sales Invoice Header"
            ELSE IF ("Document Type" = CONST("Credit Memo")) "Sales Cr.Memo Header";
        }

        field(60; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line".Amount WHERE("Document No." = FIELD("No.")));
        }

        field(61; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
        }

        field(73707; "Tax No."; Code[30])
        {
            Caption = 'Tax No.';
        }

        field(73709; Exported; Boolean)
        {
            Caption = 'Exported';
        }

        field(73710; "Exported Date"; Date)
        {
            Caption = 'Exported Date';
        }

        field(73711; Pick; Boolean)
        {
            Caption = 'Pick';
        }

        field(73718; "Pick Date"; Date)
        {
            Caption = 'Pick Date';
        }
        field(73719; "Faktur Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(73720; "Sell-to Customer Name"; Text[100])
        {

            DataClassification = ToBeClassified;
            //TableRelation = Customer.Name;
        }
        field(73721; "Tahun Pajak"; Text[4])
        {

            DataClassification = ToBeClassified;
        }
        field(73705; "Transaction Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "01","02","03","04","05","06","07","08","09";
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Customer."Transaction Code" WHERE("No." = FIELD("Sell-to Customer No.")));
        }

        field(73715; "Transaction Code1"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "00","01","02","03","04","05","06","07","08","09";
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."Transaction Code" WHERE("No." = FIELD("Sell-to Customer No.")));
        }


        field(73706; "Status Code"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "0","1";
        }
        field(73724; "NPWP No."; CODE[30])
        {

            DataClassification = ToBeClassified;
        }
        field(73725; "NPWP Name."; Text[150])
        {

            DataClassification = ToBeClassified;
        }
        field(73726; "NPWP Address"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(73727; "Amount DPP"; Decimal)
        {
            DataClassification = ToBeClassified;
            InitValue = 0;
        }
        field(73728; "Amount PPNBM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73729; "Amount Prepayment"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73730; "Amount Prepayment DPP"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73731; "Amount Prepayment PPN"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73732; "Amount Prepayment PPNBM"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(73733; "Additional Notes"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(73734; Reference; text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(73735; "Additional Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(73736; "Sell-to Customer Name1"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
            //TableRelation = Customer.Name;
        }
        field(73737; "NPWP No.1"; Text[100])
        {
            CalcFormula = lookup(Customer."NPWP No" where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
            //TableRelation = Customer.Name;
        }
        field(73738; "NPWP Address1"; Text[150])
        {
            CalcFormula = lookup(Customer."NPWP Address" where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
            //TableRelation = Customer.Name;
        }
        field(73739; "NPWP Name.1"; Text[150])
        {
            CalcFormula = lookup(Customer."NPWP Name" where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
            //TableRelation = Customer.Name;
        }

        field(73740; "NPWP Address21"; Text[150])
        {
            CalcFormula = lookup(Customer."NPWP Address 2" where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
            //TableRelation = Customer.Name;
        }
        field(73741; validasi; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(73742; "Branch Code"; code[3])
        {
            DataClassification = ToBeClassified;
        }

        field(73743; "Branch Code1"; code[3])
        {
            CalcFormula = lookup(Customer."Branch Code" where("No." = field("Sell-to Customer No.")));
            FieldClass = FlowField;
        }
        field(73744; "Apply Doc"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(73745; "vat %"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(73750; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
            Description = 'Indicates if Amount PPNBM is valid for filtering.';
        }
        field(73751; "Has VAT"; Boolean)
        {
            Caption = 'Has VAT';
        }
        field(73752; "VAT PERCENT"; Decimal)
        {
            DataClassification = ToBeClassified;


        }

        field(73753; "VAT PERCENT1"; Decimal)
        {

            CalcFormula = Sum("Sales Invoice Line"."VAT %" WHERE("Document No." = FIELD("No.")));
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

    trigger OnModify()
    begin
        if (Rec.Pick) and (Rec."Pick Date" = 0D) then begin
            Rec."Pick Date" := TODAY;

        end else if not Rec.Pick then begin
            Rec."Pick Date" := 0D;

        end;

        Rec."Amount PPNBM" := Rec."Amount Including VAT" - Rec.Amount;
        UpdateIsValid();
        UpdateHasVAT();
    end;

    trigger OnInsert()
    begin
        Rec."Amount PPNBM" := Rec."Amount Including VAT" - Rec.Amount;
        UpdateIsValid();
        UpdateHasVAT();

    end;

    procedure UpdateIsValid()
    begin
        // Menghitung Amount PPNBM
        "Amount PPNBM" := "Amount Including VAT" - Amount;

        // Jika Amount PPNBM ≠ 0, tandai Is Valid = TRUE
        if "Amount PPNBM" <> 0 then
            "Is Valid" := true
        else
            "Is Valid" := false;
    end;

    procedure UpdateHasVAT()
    begin
        if "Amount Including VAT" > Amount then
            "Has VAT" := true
        else
            "Has VAT" := false;
    end;



}