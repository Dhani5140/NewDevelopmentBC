// Definisi halaman baru dengan ID 50110 dan nama "DataTypesCard"
page 52227 DataTypesCard1
{
    // Mengatur jenis halaman sebagai Card
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Caption = 'Data Types Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                // Bagian layout tidak memiliki field karena hanya menampilkan variabel melalui pesan
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // Area aksi tidak memiliki aksi khusus untuk halaman ini
        }
    }

    // Trigger yang dijalankan saat halaman dibuka
    trigger OnOpenPage()
    begin
        // Menampilkan pesan berisi nilai dari setiap variabel
        Message('The value of %1 is %2', 'YesOrNo', YesOrNo);             // Menampilkan nilai default YesOrNo (Boolean)
        Message('The value of %1 is %2', 'Amount', Amount);                // Menampilkan nilai default Amount (Decimal)
        Message('The value of %1 is %2', 'When Was It', "When Was It");    // Menampilkan nilai default When Was It (Date)
        Message('The value of %1 is %2', 'What Time', "What Time");        // Menampilkan nilai default What Time (Time)
        Message('The value of %1 is %2', 'Description', Description);      // Menampilkan nilai default Description (Text[30])
        Message('The value of %1 is %2', 'Code Number', "Code Number");    // Menampilkan nilai default Code Number (Code[10])
        Message('The value of %1 is %2', 'Ch', Ch);                        // Menampilkan nilai default Ch (Char)
        Message('The value of %1 is %2', 'Color', Color);                  // Menampilkan nilai default Color (Option)
    end;

    // Deklarasi variabel global
    var
        LoopNo: Integer;                          // Variabel integer untuk loop
        YesOrNo: Boolean;                         // Variabel boolean
        Amount: Decimal;                          // Variabel decimal untuk jumlah
        "When Was It": Date;                      // Variabel tanggal
        "What Time": Time;                        // Variabel waktu
        Description: Text[30];                    // Variabel teks dengan panjang maksimum 30 karakter
        "Code Number": Code[10];                  // Variabel kode dengan panjang maksimum 10 karakter
        Ch: Char;                                 // Variabel karakter tunggal
        Color: Option Red,Orange,Yellow,Green,Blue,Violet; // Variabel pilihan dengan opsi warna
}
