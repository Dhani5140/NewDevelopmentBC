// Definisikan tabel baru dengan ID 50110 dan nama "DataTypesExample"
table 52225 DataTypesExample
{
    DataClassification = ToBeClassified; // Mengatur klasifikasi data menjadi "ToBeClassified" untuk data yang memerlukan klasifikasi lebih lanjut
    Caption = 'Data Types Example'; // Judul yang akan tampil untuk tabel ini

    // Deklarasi field atau kolom dalam tabel
    fields
    {
        // ID sebagai kunci utama tabel
        field(1; ID; Integer)
        {
            DataClassification = SystemMetadata;
        }

        // Field bertipe Integer untuk menyimpan nomor loop
        field(2; LoopNo; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Loop No';
        }

        // Field Boolean untuk menyimpan nilai Ya atau Tidak
        field(3; YesOrNo; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Yes or No';
        }

        // Field Decimal untuk menyimpan jumlah
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }

        // Field Date untuk menyimpan tanggal
        field(5; "When Was It"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'When Was It';
        }

        // Field Time untuk menyimpan waktu
        field(6; "What Time"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'What Time';
        }

        // Field Text untuk menyimpan deskripsi hingga 30 karakter
        field(7; Description; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

        // Field Code untuk menyimpan kode hingga 10 karakter
        field(8; "Code Number"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code Number';
        }


        field(9; Ch; Text[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Character';
        }

        // Field Option untuk menyimpan pilihan warna
        field(10; Color; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Color';
            OptionMembers = Red,Orange,Yellow,Green,Blue,Violet; // Pilihan yang tersedia dalam opsi ini
        }
    }

    // Menentukan kunci utama (Primary Key) dari tabel
    keys
    {
        key(PK; ID) { Clustered = true; }
    }
}
