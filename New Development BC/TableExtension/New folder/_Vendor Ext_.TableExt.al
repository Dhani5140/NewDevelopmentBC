tableextension 80131 "Vendor Ext" extends Vendor
{
    fields
    {
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
        field(73709; "NPWP NO."; CODE[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "WHT Posting Group"; code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }

        field(50105; "WHT Business Posting Group"; Code[20])
        {
            TableRelation = "WHT Buss Posting Group";
        }
        field(50106; "WHT Product Posting Group"; Code[20])
        {
            TableRelation = "WHT Product Posting Group";
        }
        field(50107; ABN; Text[11])
        {
            Caption = 'ABN';
            Numeric = true;

            trigger OnValidate()
            begin
                if "WHT Business Posting Group" <> '' then
                    Error('Text15000', FieldCaption("WHT Business Posting Group"));

                // ABNManagement.CheckABN(ABN, 1);
                // if ABN = '' then
                //     Registered := false;
            end;
        }
        field(50108; "Foreign Vend"; Boolean)
        {
            Caption = 'Foreign Vend';

            // trigger OnValidate()
            // begin
            //     if "Foreign Vend" then begin
            //         ABN := '';
            //         "ABN Division Part No." := '';
            //     end;
            // end;
        }

        field(50100; "WHT Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tax Setup2"."WHT Code";
        }
        field(50101; "Apply WHT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }
    var
        myInt: Integer;
}
