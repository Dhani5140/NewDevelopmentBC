codeunit 59102 "CSV Import Management"
{
    procedure ImportCSVToGenJournal()
    var
        GenJournalLine: Record "Gen. Journal Line";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        InStr: InStream;
        LineText: Text;
        FieldValues: List of [Text];
        Window: Dialog;
        RowNo: Integer;
        MaxRowNo: Integer;
        CurrentRow: Integer;
        StartTime: Time;
        ElapsedSeconds: Decimal;
        ElapsedMinutes: Decimal;
        RemainingSeconds: Decimal;
        ProcessedTime: Text;
        TotalSeconds: Decimal;
    begin
        // Import file CSV
        if FileMgt.BLOBImport(TempBlob, 'Pilih File CSV') = '' then
            exit;

        StartTime := Time;
        TempBlob.CreateInStream(InStr);
        Window.Open('Baris yang diproses: #1### dari #2###\' +
                    'Waktu berlalu: #3#\' +
                    'Estimasi sisa waktu: #4# detik');

        // Hitung jumlah baris
        MaxRowNo := 0;
        while not InStr.EOS do begin
            InStr.ReadText(LineText);
            MaxRowNo += 1;
        end;

        // Reset InStream untuk membaca dari awal
        TempBlob.CreateInStream(InStr);
        CurrentRow := 0;
        RowNo := 0;

        // Skip header
        InStr.ReadText(LineText);

        while not InStr.EOS do begin
            InStr.ReadText(LineText);
            RowNo += 1;
            CurrentRow += 1;

            // Hitung waktu yang berlalu
            ElapsedSeconds := (Time - StartTime) / 1000;
            ElapsedMinutes := ROUND(ElapsedSeconds / 60, 0.01);
            TotalSeconds := ElapsedSeconds - (ROUND(ElapsedMinutes, 1, '<') * 60);

            // Hitung estimasi waktu tersisa
            if CurrentRow > 1 then
                RemainingSeconds := ROUND((ElapsedSeconds / CurrentRow) * (MaxRowNo - CurrentRow), 0.01);

            ProcessedTime := StrSubstNo('%1 menit %2 detik',
                ROUND(ElapsedMinutes, 1, '<'),
                ROUND(TotalSeconds, 0.01));

            Window.Update(1, CurrentRow);
            Window.Update(2, MaxRowNo - 1); // Kurangi 1 untuk header
            Window.Update(3, ProcessedTime);
            Window.Update(4, ROUND(RemainingSeconds, 0.01));

            // Parse CSV line
            FieldValues := LineText.Split(',');
            if FieldValues.Count >= 8 then begin
                Clear(GenJournalLine);
                GenJournalLine.Init();
                GenJournalLine."Journal Template Name" := FieldValues.Get(1);
                GenJournalLine."Journal Batch Name" := FieldValues.Get(2);
                Evaluate(GenJournalLine."Line No.", Format(RowNo * 10000));

                if Evaluate(GenJournalLine."Posting Date", FieldValues.Get(3)) then
                    GenJournalLine.Validate("Posting Date");

                GenJournalLine.Validate("Document No.", FieldValues.Get(4));
                GenJournalLine.Validate("Account Type", GetAccountType(FieldValues.Get(5)));
                GenJournalLine.Validate("Account No.", FieldValues.Get(6));
                GenJournalLine.Validate(Description, FieldValues.Get(7));

                if Evaluate(GenJournalLine.Amount, FieldValues.Get(8)) then
                    GenJournalLine.Validate(Amount);

                if GenJournalLine.Insert(true) then;
                Commit();
            end;
        end;

        Window.Close();

        // Hitung total waktu final
        ElapsedSeconds := (Time - StartTime) / 1000;
        ElapsedMinutes := ROUND(ElapsedSeconds / 60, 0.01);
        TotalSeconds := ElapsedSeconds - (ROUND(ElapsedMinutes, 1, '<') * 60);

        ProcessedTime := StrSubstNo('Import selesai dalam %1 menit %2 detik',
            ROUND(ElapsedMinutes, 1, '<'),
            ROUND(TotalSeconds, 0.01));
        Message(ProcessedTime);
    end;

    local procedure GetAccountType(AccountTypeText: Text): Enum "Gen. Journal Account Type"
    var
        GenJournalAccountType: Enum "Gen. Journal Account Type";
    begin
        case AccountTypeText of
            'G/L Account':
                exit(GenJournalAccountType::"G/L Account");
            'Customer':
                exit(GenJournalAccountType::Customer);
            'Vendor':
                exit(GenJournalAccountType::Vendor);
            'Bank Account':
                exit(GenJournalAccountType::"Bank Account");
            else
                exit(GenJournalAccountType::"G/L Account");
        end;
    end;
}
