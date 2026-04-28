
//     // Deklarasi variabel
// var
//     CompanyInformation: Record "Company Information"; // Variabel untuk record "Company Information"
//     InStr: InStream; // Variabel InStream untuk membaca data dari BLOB

// begin
//     // Memeriksa apakah data pertama dari record "Company Information" ditemukan
//     if (CompanyInformation.FindFirst()) then begin 
//         // Memuat (menghitung) BLOB dari field Picture dalam memori
//         CompanyInformation.CalcFields(CompanyInformation.Picture);

//         // Membuat InStream dari BLOB field Picture, siap untuk dibaca
//         CompanyInformation.Picture.CreateInStream(InStr);
//     end;
// end;

