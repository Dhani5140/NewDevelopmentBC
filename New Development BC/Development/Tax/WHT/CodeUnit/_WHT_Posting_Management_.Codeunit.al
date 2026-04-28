// codeunit 51184 "WHT Posting Management invoice"
// {

//     Permissions = TableData "Purchase Line" = rimd,
//                   TableData "Tax Setup2" = rimd,
//                   TableData "Gen. Journal Line" = rimd;

//     // Prosedur utama untuk memproses dan memposting Withholding Tax (WHT)
//     procedure PostWithholdingTax(PurchHeader: Record "Purchase Header"; IsPreview: Boolean)
//     var
//         PurchLine: Record "Purchase Line";
//         TaxSetup: Record "Tax Setup2";
//         GenJournalLine: Record "Gen. Journal Line";
//         WHTPercent: Decimal;
//         WHTAmount: Decimal;
//         WHTAccount: Code[20];
//         JournalTemplate: Code[10];
//         JournalBatch: Code[10];
//         LineNo: Integer;
//     begin
//         // Pastikan hanya Purchase Invoice yang diproses
//         if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then
//             Error('This process is only for Purchase Invoice, not for other document types.');

//         // Ambil data Purchase Line berdasarkan Document No.
//         PurchLine.Reset();
//         PurchLine.SetRange("Document No.", PurchHeader."No.");

//         if not PurchLine.FindSet() then
//             Error('No lines found for Purchase Document No. "%1".', PurchHeader."No.");

//         // Tentukan template jurnal dan batch yang digunakan
//         JournalTemplate := 'GENERAL';  // Pastikan ini ada dalam sistem
//         JournalBatch := 'DEFAULT';    // Pastikan ini juga ada dalam sistem

//         // Ambil LineNo otomatis berdasarkan jumlah data yang ada di GenJournalLine
//         LineNo := 10000; // Bisa disesuaikan, jika perlu logika lain untuk pengaturan LineNo

//         repeat
//             // Ambil setup untuk WHT Code
//             if not TaxSetup.Get(PurchLine."WHT Code") then
//                 Error('WHT Code "%1" is not configured in WHT Posting Setup.', PurchLine."WHT Code");

//             WHTPercent := TaxSetup."WHT Percent";
//             WHTAccount := TaxSetup."WHT Payable Account";

//             if WHTAccount = '' then
//                 Error('WHT Payable Account is missing for WHT Code "%1".', PurchLine."WHT Code");

//             // Hitung jumlah WHT yang akan diposting
//             WHTAmount := PurchLine."Line Amount" * WHTPercent / 100;

//             // Inisialisasi entri jurnal untuk WHT
//             GenJournalLine.Init();
//             //GenJournalLine."Journal Template Name" := JournalTemplate;
//             //GenJournalLine."Journal Batch Name" := JournalBatch;
//             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
//             GenJournalLine."Account No." := WHTAccount;
//             GenJournalLine."Posting Date" := PurchHeader."Posting Date";
//             GenJournalLine.Amount := -WHTAmount;
//             GenJournalLine."Document No." := PurchHeader."No.";
//             GenJournalLine."Description" := 'Withholding Tax - ' + PurchHeader."No.";
//             GenJournalLine."Line No." := LineNo; // Set Line No manually, increment as needed

//             // Proses entri jurnal berdasarkan mode (preview atau posting)
//             if IsPreview then begin
//                 // Masukkan entri jurnal untuk preview
//                 GenJournalLine.Insert();
//                 // Tampilkan pesan di preview
//                 Message('Preview: Account No = %1, Amount = %2', GenJournalLine."Account No.", GenJournalLine.Amount);
//             end else begin
//                 // Jika bukan preview, insert dan lakukan posting jurnal
//                 GenJournalLine.Insert();
//                 // Memanggil kode unit untuk melakukan posting
//                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post Line", GenJournalLine);
//             end;

//             // Increment Line No untuk setiap baris jurnal
//             LineNo := LineNo + 1;

//         until PurchLine.Next() = 0;

//         // Mesej yang memberi informasi status akhir (preview atau posting)
//         if IsPreview then
//             Message('Preview complete for Purchase Document No. "%1".', PurchHeader."No.")
//         else
//             Message('WHT successfully posted for Purchase Document No. "%1".', PurchHeader."No.");
//     end;

//     // Event subscriber yang memicu posting WHT sebelum Purchase Posting dijalankan
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeRunPurchPost', '', false, false)]
//     local procedure "Purch.-Post (Yes/No)_OnBeforeRunPurchPost"(var PurchaseHeader: Record "Purchase Header")
//     begin
//         // Pastikan hanya Purchase Invoice yang diproses
//         if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Invoice then
//             Error('This process is only for Purchase Invoice.');

//         // Pesan untuk memastikan event subscriber dipanggil
//         Message('Event triggered for Purchase Document No. %1', PurchaseHeader."No.");
//         // Memanggil prosedur untuk proses WHT dalam preview mode
//         PostWithholdingTax(PurchaseHeader, true);  // true berarti mode preview
//     end;
// }


