codeunit 50100 CsvGenerate
{
    trigger OnRun()
    begin

    end;

    procedure generatafile(data: Record "Cust. Ledger Entry")
    var
        inst: InStream;
        outst: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        Txtbuilder: TextBuilder;
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        FileName := 'PajakKeluaran_' + Format(CurrentDateTime) + '.csv';
        Txtbuilder.AppendLine('FK' + ';' + 'Tanggal Faktur' + ';' + 'Nama'); //FK
        Txtbuilder.AppendLine('LT' + ';' + 'RT' + ';' + 'RW');               //LT
        Txtbuilder.AppendLine('OP' + ';' + 'Diskon' + ';' + 'DPP');          //OP
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetFilter("Document No.", data."Document No.");
        if CustLedgerEntry.FindSet() then begin
            repeat
                Txtbuilder.AppendLine('FK' + ';' + AddDoubleQuotes(Format(CustLedgerEntry."Posting Date")) + ';' + AddDoubleQuotes(Format(CustLedgerEntry."Customer Name"))); //FK
                Txtbuilder.AppendLine('LT' + ';' + '-' + ';' + '-');                                                                                                          //LT
                Txtbuilder.AppendLine('OP' + ';' + AddDoubleQuotes(Format(CustLedgerEntry."Inv. Discount (LCY)")) + ';' + AddDoubleQuotes(Format(CustLedgerEntry.Amount)));   //OP
            until CustLedgerEntry.Next() = 0;
        end;

        TempBlob.CreateOutStream(outst);
        outst.WriteText(Txtbuilder.ToText());
        TempBlob.CreateInStream(inst);
        DownloadFromStream(inst, '', '', '', FileName);
    end;

    local procedure AddDoubleQuotes(FieldValue: Text): Text
    begin
        exit('"' + FieldValue + '"');
    end;
}