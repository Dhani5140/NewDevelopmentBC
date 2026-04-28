codeunit 59201 "Excel Import Management batch"
{
    procedure ImportExcelToGenJournal()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
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
        // Validasi Template dan Batch
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", 'GENERAL');
        GenJnlBatch.SetRange(Name, 'DEFAULT');
        if not GenJnlBatch.FindFirst() then
            Error('Template GENERAL dengan batch DEFAULT tidak ditemukan');

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

            // Update progress window
            UpdateProgressWindow(
                Window, CurrentRow, MaxRowNo, StartTime,
                ElapsedSeconds, ElapsedMinutes, RemainingSeconds,
                TotalSeconds, ProcessedTime);

            Clear(GenJournalLine);
            GenJournalLine.Init();
            // Set template dan batch secara hardcoded
            GenJournalLine."Journal Template Name" := 'GENERAL';
            GenJournalLine."Journal Batch Name" := 'DEFAULT';
            //GenJournalLine."Account Type" := 'G/L Account';
            Evaluate(GenJournalLine."Line No.", Format(RowNo * 10000));

            // if Evaluate(GenJournalLine."Posting Date", GetValueAtCell(RowNo, 1, TempExcelBuffer)) then
            //     GenJournalLine.Validate("Posting Date");

            //GenJournalLine.Validate("Document No.", GetValueAtCell(RowNo, 2, TempExcelBuffer));
            //GenJournalLine.Validate("Account Type", GetAccountType(GetValueAtCell(RowNo, 3, TempExcelBuffer)));

            GenJournalLine.Validate(Description, GetValueAtCell(RowNo, 1, TempExcelBuffer));
            GenJournalLine.Validate("Account No.", GetValueAtCell(RowNo, 2, TempExcelBuffer));
            //GenJournalLine.Validate("Debit Amount",GetValueAtCell(RowNo,3,TempExcelBuffer));

            if Evaluate(GenJournalLine."Debit Amount", GetValueAtCell(RowNo, 3, TempExcelBuffer)) then
                GenJournalLine.Validate("Debit Amount");

            if Evaluate(GenJournalLine."Credit Amount", GetValueAtCell(RowNo, 4, TempExcelBuffer)) then
                GenJournalLine.Validate("Credit Amount");

            GenJournalLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 5, TempExcelBuffer));

            if Evaluate(GenJournalLine."Posting Date", GetValueAtCell(RowNo, 6, TempExcelBuffer)) then
                GenJournalLine.Validate("Posting Date");



            // if Evaluate(GenJournalLine.Amount, GetValueAtCell(RowNo, 6, TempExcelBuffer)) then
            //     GenJournalLine.Validate(Amount);

            if GenJournalLine.Insert(true) then;
            Commit();
        end;

        Window.Close();
        ShowCompletionMessage(StartTime);
    end;

    local procedure UpdateProgressWindow(var Window: Dialog; CurrentRow: Integer; MaxRowNo: Integer;
        StartTime: Time; var ElapsedSeconds: Decimal; var ElapsedMinutes: Decimal;
        var RemainingSeconds: Decimal; var TotalSeconds: Decimal; var ProcessedTime: Text)
    begin
        ElapsedSeconds := (Time - StartTime) / 1000;
        ElapsedMinutes := ROUND(ElapsedSeconds / 60, 0.01);
        TotalSeconds := ElapsedSeconds - (ROUND(ElapsedMinutes, 1, '<') * 60);

        if CurrentRow > 1 then
            RemainingSeconds := ROUND((ElapsedSeconds / CurrentRow) * (MaxRowNo - CurrentRow), 0.01);

        ProcessedTime := StrSubstNo('%1 menit %2 detik',
            ROUND(ElapsedMinutes, 1, '<'),
            ROUND(TotalSeconds, 0.01));

        Window.Update(1, CurrentRow);
        Window.Update(2, MaxRowNo);
        Window.Update(3, ProcessedTime);
        Window.Update(4, ROUND(RemainingSeconds, 0.01));
    end;

    local procedure ShowCompletionMessage(StartTime: Time)
    var
        ElapsedSeconds: Decimal;
        ElapsedMinutes: Decimal;
        TotalSeconds: Decimal;
        ProcessedTime: Text;
    begin
        ElapsedSeconds := (Time - StartTime) / 1000;
        ElapsedMinutes := ROUND(ElapsedSeconds / 60, 0.01);
        TotalSeconds := ElapsedSeconds - (ROUND(ElapsedMinutes, 1, '<') * 60);

        ProcessedTime := StrSubstNo('Import selesai dalam %1 menit %2 detik',
            ROUND(ElapsedMinutes, 1, '<'),
            ROUND(TotalSeconds, 0.01));
        Message(ProcessedTime);
    end;

    // Existing procedures remain the same
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
        case UpperCase(AccountTypeText) of
            'G/L ACCOUNT':
                exit(GenJournalAccountType::"G/L Account");
            'CUSTOMER':
                exit(GenJournalAccountType::Customer);
            'VENDOR':
                exit(GenJournalAccountType::Vendor);
            'BANK ACCOUNT':
                exit(GenJournalAccountType::"Bank Account");
            else
                exit(GenJournalAccountType::"G/L Account");
        end;
    end;

}
