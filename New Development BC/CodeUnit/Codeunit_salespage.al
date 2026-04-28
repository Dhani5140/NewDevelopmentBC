// codeunit 52333 "Calculate Amount PPNBM"
// {
//     trigger OnRun()
//     var
//         SalesTaxRecord: Record "ID Sales Tax Mgmt1";
//     begin
//         // Cari semua record di tabel
//         if SalesTaxRecord.FindSet() then
//             repeat
//                 // Hitung Amount PPNBM berdasarkan Amount dan Amount Including VAT
//                 SalesTaxRecord."Amount PPNBM" := SalesTaxRecord."Amount Including VAT" - SalesTaxRecord.Amount;
//                 SalesTaxRecord.Modify(); // Menyimpan perubahan ke database
//             until SalesTaxRecord.Next() = 0;
//         Message('Perhitungan Amount PPNBM selesai dan nilai sudah disimpan permanen.');
//     end;
// }
