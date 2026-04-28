table 81114 "Generate Pajak Table2"
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
        field(3; "Branch code"; code[20])
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
            Caption = 'Status';

            trigger OnValidate()
            begin
                if "Status Code" <> "Status Code"::Open then
                    Error('Status must be Open to modify or input data.');
            end;

        }

        field(6; Year; Code[10])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GeneratePajakTable: Record "Generate Pajak Table2";
            begin
                // Batasi input ke dua karakter
                if StrLen(Year) > 2 then
                    Year := COPYSTR(Year, 3, 4); // Potong menjadi dua karakter pertama

                if StrLen(Year) <> 2 then
                    Error('Year harus terdiri dari 2 karakter.');

                // Cek apakah Status Code adalah 'Open'
                if "Status Code" <> "Status Code"::Open then
                    Error('Dokumen tidak dapat diubah karena statusnya bukan "Open".');

                // Set filter untuk mengecek apakah kombinasi Transaction Code1, Branch Code1, dan Year sudah ada di tabel lain
                GeneratePajakTable.Reset();
                GeneratePajakTable.SetRange("Transaction Code1", "Transaction Code1");
                GeneratePajakTable.SetRange("Branch code1", "Branch code1");
                GeneratePajakTable.SetRange(Year, Year);
                GeneratePajakTable.SetRange("From No", "From No");
                GeneratePajakTable.SetRange("To No", "To No");

                // Pastikan tidak mengecek baris yang sedang diedit saat ini
                if GeneratePajakTable.FindFirst() then
                    if (GeneratePajakTable."Entry No." <> Rec."Entry No.") and
                       (GeneratePajakTable."Transaction Code1" = "Transaction Code1") and
                       (GeneratePajakTable."Branch code1" = "Branch code1") and
                       (GeneratePajakTable."From No" = "From No") and
                       (GeneratePajakTable."To No" = "To No") and
                       (GeneratePajakTable.Year = Year) then begin
                        Error('Kombinasi Transaction Code "%1", Branch Code "%2", dan Year "%3" sudah ada di dokumen lain. Tidak bisa memasukkan lagi.',
                              FORMAT("Transaction Code1"), FORMAT("Branch code1"), FORMAT(Year));
                    end;
            end;
        }
        field(7; "From No"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                GeneratePajakTable: Record "Generate Pajak Table2";
            begin


                if "From No" >= "To No" then begin
                    Error('testing');
                end;
                if "Status Code" <> "Status Code"::Open then
                    Error('Dokumen status Open');

                // Set filter untuk mengecek apakah kombinasi Transaction Code1, Branch Code1, dan Year sudah ada di tabel lain
                GeneratePajakTable.Reset();
                GeneratePajakTable.SetRange("Transaction Code1", "Transaction Code1");
                GeneratePajakTable.SetRange("Branch code1", "Branch code1");
                GeneratePajakTable.SetRange(Year, Year);
                GeneratePajakTable.SetRange("From No", "From No");
                GeneratePajakTable.SetRange("To No", "To No");

                // Pastikan tidak mengecek baris yang sedang diedit saat ini
                if GeneratePajakTable.FindFirst() then
                    if (GeneratePajakTable."Entry No." <> Rec."Entry No.") and
                       (GeneratePajakTable."Transaction Code1" = "Transaction Code1") and
                       (GeneratePajakTable."Branch code1" = "Branch code1") and
                       (GeneratePajakTable."From No" = "From No") and
                       (GeneratePajakTable."To No" = "To No") and
                       (GeneratePajakTable.Year = Year) then begin
                        Error('Kombinasi Transaction Code "%1", Branch Code "%2", dan Year "%3" sudah ada di dokumen lain. Tidak bisa memasukkan lagi.',
                              FORMAT("Transaction Code1"), FORMAT("Branch code1"), FORMAT(Year));
                    end;
            end;
        }
        field(8; "To No"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GeneratePajakTable: Record "Generate Pajak Table2";
            begin



                if "From No" >= "To No" then begin
                    Error('testing');
                end;


                if "Status Code" <> "Status Code"::Open then
                    Error('');

                // Set filter untuk mengecek apakah kombinasi Transaction Code1, Branch Code1, dan Year sudah ada di tabel lain
                GeneratePajakTable.Reset();
                GeneratePajakTable.SetRange("Transaction Code1", "Transaction Code1");
                GeneratePajakTable.SetRange("Branch code1", "Branch code1");
                GeneratePajakTable.SetRange(Year, Year);
                GeneratePajakTable.SetRange("From No", "From No");
                GeneratePajakTable.SetRange("To No", "To No");

                // Pastikan tidak mengecek baris yang sedang diedit saat ini
                if GeneratePajakTable.FindFirst() then
                    if (GeneratePajakTable."Entry No." <> Rec."Entry No.") and
                       (GeneratePajakTable."Transaction Code1" = "Transaction Code1") and
                       (GeneratePajakTable."Branch code1" = "Branch code1") and
                       (GeneratePajakTable."From No" = "From No") and
                       (GeneratePajakTable."To No" = "To No") and
                       (GeneratePajakTable.Year = Year) then begin
                        Error('Kombinasi Transaction Code "%1", Branch Code "%2", dan Year "%3" sudah ada di dokumen lain. Tidak bisa memasukkan lagi.',
                              FORMAT("Transaction Code1"), FORMAT("Branch code1"), FORMAT(Year));
                    end;
            end;
        }
        field(9; "Number Prefix"; code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(10; "Transaction Code1"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "00","01","02","03","04","05","06","07","08","09";
            trigger OnValidate()
            var
                GeneratePajakTable: Record "Generate Pajak Table2";
            begin
                // Cek apakah Status Code adalah 'Open'
                if "Status Code" <> "Status Code"::Open then
                    Error('Dokumen tidak dapat diubah karena statusnya bukan "Open".');

                // Set filter untuk mengecek apakah kombinasi Transaction Code1, Branch Code1, dan Year sudah ada di tabel lain
                GeneratePajakTable.Reset();
                GeneratePajakTable.SetRange("Transaction Code1", "Transaction Code1");
                GeneratePajakTable.SetRange("Branch code1", "Branch code1");
                GeneratePajakTable.SetRange(Year, Year);
                GeneratePajakTable.SetRange("From No", "From No");
                GeneratePajakTable.SetRange("To No", "To No");

                // Pastikan tidak mengecek baris yang sedang diedit saat ini
                if GeneratePajakTable.FindFirst() then
                    if (GeneratePajakTable."Entry No." <> Rec."Entry No.") and
                       (GeneratePajakTable."Transaction Code1" = "Transaction Code1") and
                       (GeneratePajakTable."Branch code1" = "Branch code1") and
                       (GeneratePajakTable."From No" = "From No") and
                       (GeneratePajakTable."To No" = "To No") and
                       (GeneratePajakTable.Year = Year) then begin
                        Error('Kombinasi Transaction Code "%1", Branch Code "%2", dan Year "%3" sudah ada di dokumen lain. Tidak bisa memasukkan lagi.',
                              FORMAT("Transaction Code1"), FORMAT("Branch code1"), FORMAT(Year));
                    end;
            end;
        }
        field(11; "Branch code1"; code[3])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                GeneratePajakTable: Record "Generate Pajak Table2";
            begin
                // Cek apakah Status Code adalah 'Open'
                if "Status Code" <> "Status Code"::Open then
                    Error('Dokumen tidak dapat diubah karena statusnya bukan "Open".');

                // Set filter untuk mengecek apakah kombinasi Transaction Code1, Branch Code1, dan Year sudah ada di tabel lain
                GeneratePajakTable.Reset();
                GeneratePajakTable.SetRange("Transaction Code1", "Transaction Code1");
                GeneratePajakTable.SetRange("Branch code1", "Branch code1");
                GeneratePajakTable.SetRange(Year, Year);
                GeneratePajakTable.SetRange("From No", "From No");
                GeneratePajakTable.SetRange("To No", "To No");

                // Pastikan tidak mengecek baris yang sedang diedit saat ini
                if GeneratePajakTable.FindFirst() then
                    if (GeneratePajakTable."Entry No." <> Rec."Entry No.") and
                       (GeneratePajakTable."Transaction Code1" = "Transaction Code1") and
                       (GeneratePajakTable."Branch code1" = "Branch code1") and
                       (GeneratePajakTable."From No" = "From No") and
                       (GeneratePajakTable."To No" = "To No") and
                       (GeneratePajakTable.Year = Year) then begin
                        Error('Kombinasi Transaction Code "%1", Branch Code "%2", dan Year "%3" sudah ada di dokumen lain. Tidak bisa memasukkan lagi.',
                              FORMAT("Transaction Code1"), FORMAT("Branch code1"), FORMAT(Year));
                    end;
            end;

        }
        field(12; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }

        field(13; "Status Code Pajak"; Option)
        {
            Description = 'DIS.TAX';
            OptionMembers = "0","1";
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
        // if "From No" >= "To No" then begin
        //     Error('testing');
        // end;

        "Number Prefix" := GenerateNumberPrefix(Year, "Branch code", "Transaction Code");
        "Status Code" := "Status Code"::Open


    end;

    trigger OnModify()
    begin
        // if "From No" >= "To No" then begin
        //     Error('testing');
        // end;

        // TestField("Status Code", "Status Code"::Open); // Hanya bisa modify jika status Open
        "Number Prefix" := GenerateNumberPrefix(Year, "Branch code", "Transaction Code");

    end;

    trigger OnDelete()
    begin
        //TestField("Status Code", "Status Code"::Open);
    end;

    trigger OnRename()
    begin

    end;

    procedure GenerateNumberPrefix(Year: Code[10]; BranchCode: code[20]; TransactionCode: Code[20]): Code[20]
    var

    begin
        // Konversi nilai integer ke string dengan panjang tetap

        exit(Year + BranchCode + TransactionCode);
    end;

}