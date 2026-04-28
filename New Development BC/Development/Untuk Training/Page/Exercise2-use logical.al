// Mendefinisikan halaman baru dengan ID 50111 dan nama "Expressions Card"
page 50111 "Expressions Card"
{
    // Menentukan jenis halaman sebagai Card dan kategori penggunaan sebagai Dokumen
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;

    // Menentukan judul halaman yang akan tampil di antarmuka pengguna
    Caption = 'Expressions Card';

    // Bagian layout untuk menampilkan area konten halaman
    layout
    {
        // Area konten utama
        area(Content)
        {
            // Grup pertama untuk masukan (input)
            group(Input)
            {
                // Judul grup input
                Caption = 'Input';

                // Field pertama untuk Value1 (input pertama)
                field(Value1; Value1)
                {
                    ApplicationArea = All; // Menampilkan field di seluruh area aplikasi
                    ToolTip = 'Masukkan nilai untuk Value1.'; // Tooltip yang muncul saat kursor diarahkan
                    Caption = 'Value1'; // Menentukan judul field
                }

                // Field kedua untuk Value2 (input kedua)
                field(Value2; Value2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Masukkan nilai untuk Value2.'; // Tooltip untuk penjelasan field
                    Caption = 'Value2';
                }
            }

            // Grup kedua untuk keluaran (output)
            group(Output)
            {
                // Judul grup output
                Caption = 'Output';

                // Field untuk Result yang menunjukkan hasil perbandingan
                field(Result; Result)
                {
                    ApplicationArea = All;
                    ToolTip = 'Hasil dari operasi.'; // Tooltip menjelaskan fungsi field
                    Caption = 'Result';
                    Editable = false; // Field ini tidak bisa di-edit oleh pengguna
                }
                field(Tambah; Tambah)
                {
                    ApplicationArea = All;
                    ToolTip = 'Hasil dari operasi.'; // Tooltip menjelaskan fungsi field
                    Caption = 'Result';
                    Editable = false; // Field ini tidak bisa di-edit oleh pengguna
                }
                field(Kurang; Kurang)
                {
                    ApplicationArea = All;
                    ToolTip = 'Hasil dari operasi.'; // Tooltip menjelaskan fungsi field
                    Caption = 'Result';
                    Editable = false; // Field ini tidak bisa di-edit oleh pengguna
                }

            }
        }
    }

    // Bagian untuk menambahkan aksi (action) di halaman
    actions
    {

        // Area untuk aksi pemrosesan
        area(Processing)
        {
            group(Operation)
            {
                action(Add)
                {
                    ApplicationArea = All; // Aksi tersedia di seluruh area aplikasi
                    Caption = 'Execute'; // Judul aksi yang akan tampil di antarmuka
                    ToolTip = 'Klik untuk menambah hasil.'; // Tooltip saat aksi dipilih
                    Image = ExecuteBatch; // Menambahkan ikon untuk aksi
                    trigger OnAction()
                    begin
                        // Melakukan perbandingan apakah Value1 lebih besar dari Value2 dan menyimpan hasilnya ke Result
                        Tambah := Value1 + Value2;
                    end;

                }
                action(Minus)
                {
                    ApplicationArea = All; // Aksi tersedia di seluruh area aplikasi
                    Caption = 'Execute'; // Judul aksi yang akan tampil di antarmuka
                    ToolTip = 'Klik untuk mengurangkan hasil.'; // Tooltip saat aksi dipilih
                    Image = ExecuteBatch; // Menambahkan ikon untuk aksi
                    trigger OnAction()
                    begin
                        // Melakukan perbandingan apakah Value1 lebih besar dari Value2 dan menyimpan hasilnya ke Result
                        Kurang := Value1 - Value2;
                    end;

                }

            }
        }
        area(Navigation)
        {

            action(Execute)
            {
                ApplicationArea = All; // Aksi tersedia di seluruh area aplikasi
                Caption = 'Execute'; // Judul aksi yang akan tampil di antarmuka
                ToolTip = 'Klik untuk menghitung hasil.'; // Tooltip saat aksi dipilih
                Image = ExecuteBatch; // Menambahkan ikon untuk aksi
                trigger OnAction()
                begin
                    // Melakukan perbandingan apakah Value1 lebih besar dari Value2 dan menyimpan hasilnya ke Result
                    Result := Value1 > Value2;
                end;

            }
        }
    }
    // Trigger yang dijalankan saat aksi ini dipilih

    // Deklarasi variabel yang digunakan dalam halaman ini
    var
        Value1: Integer; // Variabel pertama sebagai input
        Value2: Integer; // Variabel kedua sebagai input
        Result: Boolean; // Variabel untuk menyimpan hasil perbandingan
        Tambah: Integer;
        Kurang: Integer;
}


// Penjelasan Tambahan
// PageType dan UsageCategory: Menentukan jenis halaman sebagai Card yang akan muncul di kategori Documents.

// layout: Menentukan tampilan halaman. Ada dua grup: Input untuk menampilkan nilai masukan (Value1 dan Value2) dan
// Output untuk menampilkan hasil (Result).

// actions: Menambahkan aksi Execute untuk menghitung apakah Value1 lebih besar dari Value2. Aksi ini juga memiliki ikon dan tooltip.

// OnAction Trigger: Ketika aksi Execute dipilih, kode di trigger ini dijalankan untuk melakukan perbandingan 
//dan menampilkan hasil di kolom Result.