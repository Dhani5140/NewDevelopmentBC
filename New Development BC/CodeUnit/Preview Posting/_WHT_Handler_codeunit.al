// codeunit 51155 "Post WHT"
// {
//     Subtype = Normal;

//     procedure PostWHT(var GenJournalLine: Record "Gen. Journal Line")
//     var
//         WHTSetup: Record "WHT Posting Setup";
//         NewGenJournalLine: Record "Gen. Journal Line";
//         WHTAmount: Decimal;
//         LastLineNo: Integer;
//     begin
//         if not ShouldProcessWHT(GenJournalLine) then
//             exit;

//         if not WHTSetup.FindFirst() then
//             Error('WHT Posting Setup tidak ditemukan');

//         // Hitung jumlah WHT
//         WHTAmount := CalcWHTAmount(GenJournalLine.Amount, WHTSetup);
//         if WHTAmount = 0 then
//             exit;

//         // Dapatkan nomor baris terakhir untuk jurnal baru
//         LastLineNo := GetLastLineNo(GenJournalLine);

//         // Buat entri jurnal untuk pajak pemotongan (WHT)
//         NewGenJournalLine := GenJournalLine;
//         NewGenJournalLine."Line No." := LastLineNo + 10000;
//         NewGenJournalLine.Validate("Account Type", NewGenJournalLine."Account Type"::"G/L Account");
//         NewGenJournalLine.Validate("Account No.", GetWHTAccountNo(GenJournalLine, WHTSetup));
//         NewGenJournalLine.Validate(Amount, -WHTAmount); // Jumlah negatif untuk mencatat kewajiban pajak
//         NewGenJournalLine.Description := StrSubstNo('WHT %1%', WHTSetup."WHT %");
//         NewGenJournalLine."System-Created Entry" := true;
//         NewGenJournalLine.Insert(true);

//         // Kurangi jumlah pada akun AP (Vendor)
//         if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
//             NewGenJournalLine := GenJournalLine;
//             NewGenJournalLine."Line No." := LastLineNo + 20000; // Baris baru untuk pengurangan AP
//             NewGenJournalLine.Validate("Account Type", GenJournalLine."Account Type"::Vendor);
//             NewGenJournalLine.Validate("Account No.", GenJournalLine."Account No."); // Akun Vendor Posting Group 5420
//             NewGenJournalLine.Validate(Amount, -WHTAmount); // Kurangi jumlah AP sebesar WHT
//             NewGenJournalLine.Description := 'Pengurangan AP karena WHT';
//             NewGenJournalLine."System-Created Entry" := true;
//             NewGenJournalLine.Insert(true);
//         end;

//         // Update baris jurnal asli
//         GenJournalLine.Validate(Amount, GenJournalLine.Amount - WHTAmount);
//         GenJournalLine.Modify(true);
//     end;


//     local procedure ShouldProcessWHT(GenJournalLine: Record "Gen. Journal Line"): Boolean
//     var
//         WHTSetup: Record "WHT Posting Setup";
//     begin
//         if not WHTSetup.FindFirst() then
//             exit(false);

//         if Abs(GenJournalLine.Amount) < WHTSetup."WHT %" then
//             exit(false);

//         if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Vendor then
//             exit(false);

//         exit(true);
//     end;

//     local procedure CalcWHTAmount(BaseAmount: Decimal; WHTSetup: Record "WHT Posting Setup"): Decimal
//     begin
//         exit(Round(BaseAmount * WHTSetup."WHT %" / 100));
//     end;

//     local procedure GetWHTAccountNo(GenJournalLine: Record "Gen. Journal Line"; WHTSetup: Record "WHT Posting Setup"): Code[20]
//     begin
//         case GenJournalLine."Account Type" of
//             GenJournalLine."Account Type"::Vendor:
//                 exit(WHTSetup."Payable WHT Account Code");
//             GenJournalLine."Account Type"::Customer:
//                 exit(WHTSetup."Payable WHT Account Code");
//             else
//                 Error('Account Type tidak valid untuk WHT');
//         end;
//     end;

//     local procedure GetLastLineNo(GenJournalLine: Record "Gen. Journal Line"): Integer
//     var
//         LastGenJournalLine: Record "Gen. Journal Line";
//     begin
//         LastGenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
//         LastGenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
//         if LastGenJournalLine.FindLast() then
//             exit(LastGenJournalLine."Line No.");
//         exit(0);
//     end;
// }