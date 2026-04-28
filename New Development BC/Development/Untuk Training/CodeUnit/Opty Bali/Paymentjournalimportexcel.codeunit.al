codeunit 59202 "Excel Import payment journal"
{
    procedure ImportExcelToGenJournal()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        InStr: InStream;
        SheetName: Text;
        RowNo: Integer;
        Window: Dialog;
        MaxRowNo: Integer;
        CurrentRow: Integer;
    begin
        // Validasi Template dan Batch
        ValidateJournalTemplate(GenJnlBatch);

        // Import file Excel
        if FileMgt.BLOBImport(TempBlob, 'Pilih File Excel') = '' then
            exit;

        TempBlob.CreateInStream(InStr);
        Window.Open('Memproses baris #1### dari #2###\' +
                   'Progress: @3@@@@@@@@@@@@@@@@@@');

        SheetName := TempExcelBuffer.SelectSheetsNameStream(InStr);
        TempExcelBuffer.OpenBookStream(InStr, SheetName);
        TempExcelBuffer.ReadSheet();

        // Hitung total baris
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then
            MaxRowNo := TempExcelBuffer."Row No.";

        // Proses setiap baris
        for RowNo := 2 to MaxRowNo do begin
            Window.Update(1, RowNo);
            Window.Update(2, MaxRowNo);
            Window.Update(3, Round(RowNo / MaxRowNo * 10000, 1));

            InsertJournalLine(
                GenJournalLine,
                RowNo,
                TempExcelBuffer,
                GenJnlBatch
            );
        end;

        Window.Close();
        Message('Import selesai, %1 baris berhasil diproses.', MaxRowNo - 1);
    end;

    local procedure ValidateJournalTemplate(var GenJnlBatch: Record "Gen. Journal Batch")
    begin
        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", 'PAYMENT');
        GenJnlBatch.SetRange(Name, 'CASH');
        if not GenJnlBatch.FindFirst() then
            Error('Template PAYMENT dengan batch CASH tidak ditemukan');
    end;

    local procedure InsertJournalLine(
        var GenJournalLine: Record "Gen. Journal Line";
        RowNo: Integer;
        var TempExcelBuffer: Record "Excel Buffer";
        GenJnlBatch: Record "Gen. Journal Batch")
    begin
        Clear(GenJournalLine);
        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", 'PAYMENT');
        GenJournalLine.Validate("Journal Batch Name", 'CASH');
        GenJournalLine.Validate("Line No.", RowNo * 10000);

        // Mapping kolom Excel
        GenJournalLine.Validate(Description, GetValueAtCell(RowNo, 1, TempExcelBuffer));
        GenJournalLine.Validate("Account No.", GetValueAtCell(RowNo, 2, TempExcelBuffer));

        if Evaluate(GenJournalLine."Debit Amount", GetValueAtCell(RowNo, 3, TempExcelBuffer)) then
            GenJournalLine.Validate("Debit Amount");

        if Evaluate(GenJournalLine."Credit Amount", GetValueAtCell(RowNo, 4, TempExcelBuffer)) then
            GenJournalLine.Validate("Credit Amount");

        GenJournalLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 5, TempExcelBuffer));

        if Evaluate(GenJournalLine."Posting Date", GetValueAtCell(RowNo, 6, TempExcelBuffer)) then
            GenJournalLine.Validate("Posting Date");

        if GenJournalLine.Insert(true) then;
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
}
