// page 50102 HappyDragAnddropPage
// {
//     PageType = Card; // Menentukan tipe halaman sebagai Card
//     SourceTable = Item; // Sumber data halaman berasal dari tabel Item
//     UsageCategory = Administration; // Menentukan kategori penggunaan halaman

//     layout
//     {
//         area(Content)
//         {
//             group(GroupName) // Grup yang berfungsi sebagai file drop zone
//             {
//                 FileUploadAction = ProductImageUpload; // Menetapkan aksi unggahan file pada grup

//                 field(Name; 'Name') // Menambahkan field pada halaman
//                 {
//                     FileUploadAction = ProductImageUpload; // Menetapkan field sebagai file drop zone
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             // Definisi aksi unggahan file
//             fileUploadAction(ProductImageUpload)
//             {
//                 Caption = 'Upload Product Image'; // Teks yang ditampilkan pada aksi unggah

//                 AllowMultipleFiles = true; // Mengatur aksi untuk menerima beberapa file
//                 AllowedFileExtensions = '.jpg', '.jpeg', '.png'; // Menetapkan tipe file yang diizinkan

//                 // Trigger yang dijalankan saat pengguna mengunggah file
//                 trigger OnAction(Files: List of [FileUpload])
//                 var
//                     CurrentFile: FileUpload; // Variabel untuk mengelola file yang diunggah
//                     Stream: InStream; // Variabel stream untuk membaca file
//                 begin
//                     // Loop melalui setiap file yang diunggah
//                     foreach CurrentFile in Files do begin
//                         // Membuka stream untuk membaca data dari file yang diunggah
//                         if CurrentFile.OpenInStream(Stream) then begin
//                             // Menampilkan pesan berisi nama file dan ukuran file
//                             Message('%1 has a length of %2 bytes', CurrentFile.FileName, Stream.Length);
//                             // Tambahkan kode di sini untuk memproses file sesuai kebutuhan
//                         end else
//                             Error('Gagal membuka stream untuk file %1', CurrentFile.FileName);
//                     end;
//                 end;
//             }
//         }
//     }
// }


// page 50102 HappyDragAnddropPage
// {
//     PageType = Card;
//     SourceTable = item;
//     UsageCategory = Administration;

//     layout
//     {
//         area(Content)
//         {
//             group(GroupName)
//             {
//                 FileUploadAction = ProductImageUpload;

//                 field(name; 'Name')
//                 {
//                     FileUploadAction = ProductImageUpload;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             fileUploadAction(ProductImageUpload)
//             {
//                 Caption = 'Upload product Image';

//                 AllowMultipleFiles = false;
//                 AllowedFileExtensions = '.jpg', '.jpeg', '.png';

//                 trigger OnAction(files: List of [FileInfo])
//                 var
//                     currentFile: FileInfo;
//                     stream: InStream;
//                 begin
//                     foreach currentFile in files do begin
//                         currentFile.CreateInStream(stream);
//                         // Code here to handle the file
//                         Message('%1 has a length of %2', currentFile.FileName, stream.Length);
//                     end;
//                 end;
//             }
//         }
//     }
// }
