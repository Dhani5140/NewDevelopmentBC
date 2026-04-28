codeunit 50101 "Excel Import Management"
{
    procedure ImportExcelToGenJournal()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GenJournalLine: Record "Gen. Journal Line";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        InStr: InStream;
        FileName: Text;
        SheetName: Text;
        RowNo: Integer;
        Window: Dialog;
        MaxRowNo: Integer;
        CurrentRow: Integer;
        StartTime: Time;
        ElapsedSeconds: Decimal;
        ElapsedMinutes: Decimal;
        RemainingSeconds: Decimal;
        ProcessedTime: Text;
        TotalSeconds: Decimal;
    begin
        if FileMgt.BLOBImport(TempBlob, 'Pilih File Excel') = '' then
            exit;

        StartTime := Time;
        TempBlob.CreateInStream(InStr);
        Window.Open('Baris yang diproses: #1### dari #2###\' +
                    'Waktu berlalu: #3#\' +
                    'Estimasi sisa waktu: #4# detik');

        SheetName := TempExcelBuffer.SelectSheetsNameStream(InStr);
        TempExcelBuffer.OpenBookStream(InStr, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        CurrentRow := 0;

        for RowNo := 2 to MaxRowNo do begin
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
            Window.Update(2, MaxRowNo);
            Window.Update(3, ProcessedTime);
            Window.Update(4, ROUND(RemainingSeconds, 0.01));

            Clear(GenJournalLine);
            GenJournalLine.Init();
            GenJournalLine."Journal Template Name" := GetValueAtCell(RowNo, 1, TempExcelBuffer);
            GenJournalLine."Journal Batch Name" := GetValueAtCell(RowNo, 2, TempExcelBuffer);
            Evaluate(GenJournalLine."Line No.", Format(RowNo * 10000));

            if Evaluate(GenJournalLine."Posting Date", GetValueAtCell(RowNo, 3, TempExcelBuffer)) then
                GenJournalLine.Validate("Posting Date");

            GenJournalLine.Validate("Document No.", GetValueAtCell(RowNo, 4, TempExcelBuffer));
            GenJournalLine.Validate("Account Type", GetAccountType(GetValueAtCell(RowNo, 5, TempExcelBuffer)));
            GenJournalLine.Validate("Account No.", GetValueAtCell(RowNo, 6, TempExcelBuffer));
            GenJournalLine.Validate(Description, GetValueAtCell(RowNo, 7, TempExcelBuffer));

            if Evaluate(GenJournalLine.Amount, GetValueAtCell(RowNo, 8, TempExcelBuffer)) then
                GenJournalLine.Validate(Amount);

            if GenJournalLine.Insert(true) then;
            Commit();
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

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer; var TempExcelBuffer: Record "Excel Buffer"): Text
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", RowNo);
        TempExcelBuffer.SetRange("Column No.", ColNo);
        if TempExcelBuffer.FindFirst() then
            exit(TempExcelBuffer."Cell Value as Text");
        exit('');
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
