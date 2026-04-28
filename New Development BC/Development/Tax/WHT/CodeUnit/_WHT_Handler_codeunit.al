// codeunit 51134 "WHT Posting Management"
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
//     begin
//         // Ambil data Purchase Line berdasarkan Document No.
//         PurchLine.Reset();
//         PurchLine.SetRange("Document No.", PurchHeader."No.");

//         if not PurchLine.FindSet() then
//             Error('No lines found for Purchase Document No. "%1".', PurchHeader."No.");

//         // Tentukan template jurnal dan batch yang digunakan
//         JournalTemplate := 'GENERAL';  // Pastikan ini ada dalam sistem
//         JournalBatch := 'DEFAULT';    // Pastikan ini juga ada dalam sistem

//         repeat

//             if not TaxSetup.Get(PurchLine."WHT Code") then
//                 Error('WHT Code "%1" is not configured in WHT Posting Setup.', PurchLine."WHT Code");

//             WHTPercent := TaxSetup."WHT Percent";
//             WHTAccount := TaxSetup."WHT Payable Account";

//             if WHTAccount = '' then
//                 Error('WHT Payable Account is missing for WHT Code "%1".', PurchLine."WHT Code");


//             WHTAmount := PurchLine."Line Amount" * WHTPercent / 100;


//             GenJournalLine.Init();
//             //GenJournalLine."Journal Template Name" := JournalTemplate;
//             // GenJournalLine."Journal Batch Name" := JournalBatch;
//             GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
//             GenJournalLine."Account No." := WHTAccount;
//             GenJournalLine."Posting Date" := PurchHeader."Posting Date";
//             GenJournalLine.Amount := -WHTAmount;
//             GenJournalLine."Document No." := PurchHeader."No.";
//             GenJournalLine."Description" := 'Withholding Tax - ' + PurchHeader."No.";

//             // Proses entri jurnal berdasarkan mode (preview atau posting)
//             if IsPreview then begin

//                 GenJournalLine.Insert();

//                 Message('Preview: Account No = %1, Amount = %2', GenJournalLine."Account No.", GenJournalLine.Amount);
//             end else begin

//                 GenJournalLine.Insert();

//                 Codeunit.Run(Codeunit::"Gen. Jnl.-Post Line", GenJournalLine);
//             end;

//         until PurchLine.Next() = 0;


//         if IsPreview then
//             Message('Preview complete for Purchase Document No. "%1".', PurchHeader."No.")
//         else
//             Message('WHT successfully posted for Purchase Document No. "%1".', PurchHeader."No.");
//     end;


//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeRunPurchPost', '', false, false)]
//     local procedure "Purch.-Post (Yes/No)_OnBeforeRunPurchPost"(var PurchaseHeader: Record "Purchase Header")
//     begin

//         Message('Event triggered for Purchase Document No. %1', PurchaseHeader."No.");
//         Message('Event Triggered for COS WHT');
//         PostWithholdingTax(PurchaseHeader, true);  // true berarti mode preview
//     end;

// }
