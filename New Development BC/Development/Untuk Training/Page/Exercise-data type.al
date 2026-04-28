// Definisikan halaman baru dengan ID 50110 dan nama "DataTypesCard"
page 52225 DataTypesCard2
{
    PageType = Card; // Mengatur tipe halaman menjadi Card
    ApplicationArea = All; // Mengatur area aplikasi yang dapat mengakses halaman ini
    UsageCategory = Documents; // Mengatur kategori penggunaan halaman menjadi Dokumen
    Caption = 'Data Types Card'; // Judul yang akan tampil untuk halaman ini
    SourceTable = DataTypesExample;

    layout
    {
        area(content) // Area utama untuk konten halaman
        {
            group("Data Types Information") // Group untuk mengelompokkan field dalam halaman
            {
                // Menampilkan field ID dari tabel
                field(ID; Rec.ID) { ApplicationArea = All; }

                // Menampilkan field LoopNo dari tabel
                field(LoopNo; Rec.LoopNo) { ApplicationArea = All; }

                // Menampilkan field YesOrNo dari tabel
                field(YesOrNo; Rec.YesOrNo) { ApplicationArea = All; }

                // Menampilkan field Amount dari tabel
                field(Amount; Rec.Amount) { ApplicationArea = All; }

                // Menampilkan field "When Was It" dari tabel
                field("When Was It"; Rec."When Was It") { ApplicationArea = All; }

                // Menampilkan field "What Time" dari tabel
                field("What Time"; Rec."What Time") { ApplicationArea = All; }

                // Menampilkan field Description dari tabel
                field(Description; Rec.Description) { ApplicationArea = All; }

                // Menampilkan field "Code Number" dari tabel
                field("Code Number"; Rec."Code Number") { ApplicationArea = All; }

                // Menampilkan field Ch dari tabel
                field(Ch; Rec.Ch) { ApplicationArea = All; }

                // Menampilkan field Color dari tabel
                field(Color; Rec.Color) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing) // Area untuk tombol-tombol aksi
        {
            action(DisplayDefaultValues) // Action untuk menampilkan nilai default
            {
                ApplicationArea = All;
                Caption = 'Display Default Values';

                trigger OnAction()
                begin
                    // Menampilkan nilai dari masing-masing variabel dengan Message
                    Message('The value of %1 is %2', 'YesOrNo', YesOrNo);
                    Message('The value of %1 is %2', 'Amount', Amount);
                    Message('The value of %1 is %2', 'When Was It', "When Was It");
                    Message('The value of %1 is %2', 'What Time', "What Time");
                    Message('The value of %1 is %2', 'Description', Description);
                    Message('The value of %1 is %2', 'Code Number', "Code Number");
                    Message('The value of %1 is %2', 'Ch', Ch);
                    Message('The value of %1 is %2', 'Color', Color);
                end;
            }
            action(DisplayCharValue)
            {
                ApplicationArea = All;
                Caption = 'Display Char Value';

                trigger OnAction()
                var
                    Ch: Char; // Deklarasikan variabel bertipe Char
                    CharacterText: Text[1]; // Variabel Text[1] untuk menampilkan karakter di page
                begin
                    Ch := 'A'; // Tetapkan nilai karakter ke variabel Char
                    CharacterText := Format(Ch); // Konversi Char menjadi Text[1] untuk ditampilkan

                    Message('The value of Char variable is: %1', CharacterText);
                end;
            }
        }

    }

    // Deklarasi variabel global untuk digunakan di halaman ini
    var
        LoopNo: Integer; // Variabel untuk menyimpan nomor loop
        YesOrNo: Boolean; // Variabel untuk nilai Ya atau Tidak
        Amount: Decimal; // Variabel untuk menyimpan jumlah
        "When Was It": Date; // Variabel untuk menyimpan tanggal
        "What Time": Time; // Variabel untuk menyimpan waktu
        Description: Text[30]; // Variabel untuk deskripsi hingga 30 karakter
        "Code Number": Code[10]; // Variabel untuk kode hingga 10 karakter
        Ch: Char; // Variabel untuk satu karakter
        Color: Option Red,Orange,Yellow,Green,Blue,Violet; // Variabel untuk opsi warna
}


// Penjelasan Kode
// Table DataTypesExample: Mendeklarasikan berbagai jenis data yang akan digunakan di halaman, 
//termasuk Integer, Boolean, Decimal, Date, Time, Text, Code, Char, dan Option.



// Page DataTypesCard: Halaman yang menampilkan data dari DataTypesExample dengan aksi DisplayDefaultValues untuk menunjukkan 
//nilai default dari setiap tipe data.


// Action DisplayDefaultValues: Menampilkan nilai default dari setiap variabel ketika halaman dibuka atau ketika aksi ini dijalankan.

//---------------------------------------------------------------------------------------

// Di AL Language untuk Dynamics 365 Business Central, Char memang tersedia sebagai tipe data variabel untuk menyimpan satu karakter, 
//tetapi tidak didukung sebagai tipe field dalam tabel. Berikut adalah alasan dan cara implementasi Char yang benar di AL:

// Alasan Char Tidak Didukung dalam Field Tabel
// Keterbatasan Database: Tipe data Char mungkin tidak kompatibel dengan struktur data SQL yang mendasari Dynamics 365 Business Central. Database SQL biasanya tidak memiliki tipe Char sebagai tipe field yang berdiri sendiri dalam konteks AL.
// Alternatif Text[1]: Untuk menyimpan satu karakter, Text[1] menyediakan cara penyimpanan yang efisien di database tanpa kehilangan fungsionalitas yang diberikan Char.
// Implementasi Char di AL
// Meskipun tidak bisa digunakan sebagai field dalam tabel, Char dapat digunakan sebagai variabel dalam kode AL. Ini sangat berguna untuk operasi seperti parsing atau mengakses karakter individu dalam string.

// Contoh Implementasi Char sebagai Variabel
// al
// Copy code
// page 50110 DataTypesCard
// {
//     PageType = Card;
//     ApplicationArea = All;
//     UsageCategory = Documents;
//     Caption = 'Data Types Card';

//     layout
//     {
//         area(content)
//         {
//             group("Data Types Information")
//             {
//                 // Field untuk karakter menggunakan Text[1] di tabel atau page
//                 field(Ch; CharacterText)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Character Text';
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(processing)
//         {
//             action(DisplayCharValue)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Display Char Value';

//                 trigger OnAction()
//                 var
//                     Ch: Char; // Deklarasikan variabel bertipe Char
//                     CharacterText: Text[1]; // Variabel Text[1] untuk menampilkan karakter di page
//                 begin
//                     Ch := 'A'; // Tetapkan nilai karakter ke variabel Char
//                     CharacterText := Format(Ch); // Konversi Char menjadi Text[1] untuk ditampilkan

//                     Message('The value of Char variable is: %1', CharacterText);
//                 end;
//             }
//         }
//     }

//     // Deklarasi variabel untuk field
//     var
//         CharacterText: Text[1]; // Menyimpan hasil konversi Char ke Text
// }
// Penjelasan
// Deklarasi Char sebagai Variabel: Anda dapat mendeklarasikan Ch sebagai tipe Char untuk menyimpan satu karakter.
// Konversi ke Text[1]: Gunakan fungsi Format() untuk mengonversi Char menjadi Text[1] agar dapat ditampilkan dalam tabel atau halaman.
// Penggunaan dalam Message: Char bisa digunakan dalam fungsi Message atau logika pemrograman lain di AL tanpa harus menyimpan langsung ke tabel.
// Dengan pendekatan ini, Char dapat diimplementasikan sebagai variabel untuk operasi manipulasi karakter sementara, tetapi jika perlu disimpan dalam tabel, Anda dapat mengonversinya menjadi Text[1].
