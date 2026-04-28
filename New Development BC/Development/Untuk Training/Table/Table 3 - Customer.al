table 52229 "CustomerMaster" // Definisikan ID dan Nama tabel
{
    Caption = 'Customer Master'; // Teks deskriptif untuk tabel
    DataCaptionFields = "No.", Name; // Field yang tampil di judul halaman
    DrillDownPageID = "Customer List"; // Menghubungkan ke List Page
    LookupPageID = "Customer List"; // Lookup dari halaman lain ke List Page

    fields
    {
        field(1; "No."; Code[20]) // Field Primary Key dengan tipe Code
        {
            Caption = 'Customer No.'; // Label pada UI
            NotBlank = true; // Field wajib diisi
        }

        field(2; Name; Text[100]) // Nama Customer
        {
            Caption = 'Customer Name';
        }

        field(3; "Address"; Text[100]) // Alamat Customer
        {
            Caption = 'Address';
        }

        field(4; "City"; Text[50]) // Kota Customer
        {
            Caption = 'City';
        }

        field(5; "Phone No."; Text[30]) // Nomor Telepon Customer
        {
            Caption = 'Phone Number';
        }

        field(6; "Blocked"; Option) // Status Blokir Customer
        {
            Caption = 'Blocked Status'; // Label pada UI
            OptionMembers = " ",Ship,Invoice,All; // Opsi blokir
        }
    }

    keys
    {
        key(Key1; "No.") // Kunci utama untuk mengidentifikasi record
        {
            Clustered = true; // Mengoptimalkan pencarian pada database
        }
    }
}
