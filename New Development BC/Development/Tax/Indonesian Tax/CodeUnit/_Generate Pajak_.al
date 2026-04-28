codeunit 81111 "Generate Pajak"
{
    procedure Genertad(var Generated: Record "Generate Pajak Table2")
    var
        lrecviewgenerate: Record "Table View Generate Header";
        lrecviewgenerateLine: Record "Table View Generate Line2";
        i: Integer;
        FakturPajakNo: Code[20];
        //TempBranchCode: Integer;
        TempYear: Integer;
    begin
        // Memeriksa apakah record dengan Faktur Pajak ID ada
        if not lrecviewgenerate.GET(Generated."Faktur Pajak ID") then begin
            // Inisialisasi dan memasukkan record baru jika tidak ditemukan
            lrecviewgenerate.Init();
            lrecviewgenerate."Faktur Pajak ID" := Generated."Faktur Pajak ID";
            lrecviewgenerate.Description := Generated.Description;

            // Konversi Branch Code dari Code ke Integer jika diperlukan

            lrecviewgenerate."Branch Code1" := Generated."Branch code1";
            lrecviewgenerate."Trasaction Code" := Generated."Transaction Code1";
            lrecviewgenerate."Status Code" := Generated."Status Code Pajak";
            lrecviewgenerate.Status := Generated."Status Code";


            // Konversi Year dari Code ke Integer jika diperlukan
            if EVALUATE(TempYear, Generated.Year) then
                lrecviewgenerate.Year := TempYear
            else
                Error('Invalid Year format: %1', Generated.Year);

            lrecviewgenerate."From No." := Generated."From No";
            lrecviewgenerate."To No" := Generated."To No";
            //lrecviewgenerate.Status := Generated.Status; // Pastikan field Status ada
            lrecviewgenerate.Insert(true);
        end else begin
            // Jika record sudah ada, update data lain jika perlu
            lrecviewgenerate.Validate("Faktur Pajak ID", Generated."Faktur Pajak ID");
            lrecviewgenerate.Description := Generated.Description;

            // Konversi Branch Code dari Code ke Integer jika diperlukan

            lrecviewgenerate."Branch Code1" := Generated."Branch code1";

            // Konversi Year dari Code ke Integer jika diperlukan
            if EVALUATE(TempYear, Generated.Year) then
                lrecviewgenerate.Year := TempYear
            else
                Error('Invalid Year format: %1', Generated.Year);

            lrecviewgenerate."From No." := Generated."From No";
            lrecviewgenerate."To No" := Generated."To No";
            // lrecviewgenerate.Status := Generated.Status; // Pastikan field Status ada
            lrecviewgenerate.Modify(true);
        end;

        // Menghasilkan baris berdasarkan From No dan To No
        for i := Generated."From No" to Generated."To No" do begin
            lrecviewgenerateLine.Init();
            FakturPajakNo := FORMAT(Generated."Transaction Code1") + Format(Generated."Status Code Pajak") + '-' + FORMAT(Generated.Year) + '.' + DELSTR('00000000', 1, STRLEN(FORMAT(i))) + FORMAT(i);
            ; // format 8 digit);
            lrecviewgenerateLine."Faktur Pajak No" := FakturPajakNo;
            lrecviewgenerateLine."Document No." := Generated."Faktur Pajak ID";
            lrecviewgenerateLine."Line Number" := i;
            lrecviewgenerateLine.Insert(true);
        end;

        Commit();


        Page.Run(page::"Page view Generate");

    end;
}
