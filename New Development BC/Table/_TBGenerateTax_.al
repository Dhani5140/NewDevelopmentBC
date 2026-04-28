table 81111 "Generate Pajak Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Faktur Pajak ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Branch code"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Transaction Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Status Code"; Enum "Generate Pajak Status")
        {
            DataClassification = ToBeClassified;

        }

        field(6; Year; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "From No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "To No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Number Prefix"; code[20])
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(Key1; "Faktur Pajak ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;


    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure GenerateNumberPrefix(Year: Integer; BranchCode: Integer; TransactionCode: Code[20]): Code[30]
    var
        YearStr: Text[4];
        BranchCodeStr: Text[3];
    begin
        // Debugging messages
        Message('Year: %1, BranchCode: %2', Year, BranchCode);

        // Konversi nilai integer ke string dengan panjang tetap
        YearStr := Format(Year, 0, '0000');
        BranchCodeStr := Format(BranchCode, 0, '000');

        // Debugging messages after conversion
        Message('YearStr: %1, BranchCodeStr: %2', YearStr, BranchCodeStr);

        exit(YearStr + BranchCodeStr + TransactionCode);
    end;

    procedure ValidateInputs()
    begin
        if Year = 0 then
            Error('Year tidak boleh 0.');
        if "Branch code" = 0 then
            Error('Branch code tidak boleh 0.');
        if "Transaction Code" = '' then
            Error('Transaction Code tidak boleh kosong.');
    end;

}