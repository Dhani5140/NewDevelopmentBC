page 80140 "ID Purch. Tax Document Mgmt."
{
    // version DIS.TAX
    ApplicationArea = All;
    PageType = List;
    SourceTable = "ID Purch. Tax Mgmt";
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;
    Caption = 'Pajak Masukkan';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = all;
                    Caption = 'ID';
                    Editable = false;
                }
                // field(Pick; Rec.Pick)
                // {

                //     ApplicationArea = All;
                //     trigger OnValidate()
                //     begin
                //         // Ketika Pick diaktifkan, update Pick Date
                //         if Rec.Pick and (Rec."Pick Date" = 0D) then begin
                //             Rec."Pick Date" := TODAY; // Mengisi Pick Date dengan tanggal hari ini
                //         end else if not Rec.Pick then begin
                //             Rec."Pick Date" := 0D; // Menghapus Pick Date jika Pick di-uncheck
                //         end;
                //         Rec.Modify(); // Simpan perubahan
                //         CurrPage.Update(); // Update halaman setelah perubahan
                //     end;
                // }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Invoice Date';
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Faktur Pajak No';
                }
                field("Tahun Pajak"; Rec."Tahun Pajak")
                {
                    ApplicationArea = all;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("NPWP Name"; Rec."NPWP Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; gdecDocAmount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NPWP Address"; Rec."NPWP Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount Incl. VAT"; gdecDocAmountInclVAT)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("VAT Amount"; VATAMount)
                {
                    ApplicationArea = All;
                }

                field("Amount Prepayment DPP"; Rec."Amount Prepayment DPP")
                {
                    ApplicationArea = all;
                }

                field("Amount Prepayment PPN"; Rec."Amount Prepayment PPN")
                {
                    ApplicationArea = all;
                }

                field("Amount Prepayment PPNBM"; Rec."Amount Prepayment PPNBM")
                {
                    ApplicationArea = all;
                }

                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = all;
                }
                field("Additional Notes"; Rec."Additional Notes")
                {
                    ApplicationArea = all;
                }


                // field("Pick Date"; Rec."Pick Date")
                // {
                //     ApplicationArea = all;
                // }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                // field("Document No"; Rec."Document No")
                // {
                //     ApplicationArea = all;
                // }

                // field("Faktur Date"; Rec."Faktur Date")
                // {
                //     ApplicationArea = all;
                // }
                // field("Faktur Pajak No"; Rec."Faktur Pajak No")
                // {
                //     ApplicationArea = all;
                // }






                // field("Vendor Name"; Rec."Vendor Name")
                // {
                //     ApplicationArea = all;
                // }

                field(Validasi; Rec.Validasi)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Exported; Rec.Exported)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Exported Date"; Rec."Exported Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Pick All")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
                begin
                    lrecPurchTaxDoc.CopyFilters(Rec);
                    IF lrecPurchTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecPurchTaxDoc.Pick := TRUE;
                            lrecPurchTaxDoc.MODIFY();
                        UNTIL lrecPurchTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Unpick All")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
                begin
                    lrecPurchTaxDoc.CopyFilters(Rec);
                    IF lrecPurchTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecPurchTaxDoc.Pick := FALSE;
                            lrecPurchTaxDoc.MODIFY();
                        UNTIL lrecPurchTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Edit Pajak Masukan")
            {
                ApplicationArea = All;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Edit Pajak Masukan";
                RunPageLink = "No." = field("No.");
                // trigger OnAction()
                // var
                //     lrecSalesShipment: Record "Sales Shipment Header";
                //     lRecEditPajakMasukan: Record "ID Purch. Tax Mgmt";
                // begin
                //     lRecEditPajakMasukan.RESET();
                //     lRecEditPajakMasukan.SetFilter("No.", Rec."No.");
                //     IF lRecEditPajakMasukan.FINDSET() THEN begin
                //         Page.RunModal(50020, lRecEditPajakMasukan);
                //     END;
                // end;
            }
            // action("Generate Tax No.")
            // {
            //     ApplicationArea = All;
            //     trigger OnAction();
            //     var
            //         lrecTaxRegistration: Record "Tax Registration";
            //         lrecSalesTaxDoc: Record "Sales Tax Documents";
            //     begin
            //         lrecSalesTaxDoc.RESET();
            //         lrecSalesTaxDoc.SETRANGE(Pick, TRUE);
            //         lrecSalesTaxDoc.SETRANGE("Document Type", lrecSalesTaxDoc."Document Type"::Invoice);
            //         lrecSalesTaxDoc.SETRANGE("Tax No.", '');
            //         IF lrecSalesTaxDoc.FINDSET() THEN
            //             REPEAT
            //                 fGenerateTaxNo(lrecSalesTaxDoc);
            //             UNTIL lrecSalesTaxDoc.NEXT = 0;
            //     end;
            // }
            // action("Export Pajak Masukan")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export E-Faktur';
            //     Image = ExportToExcel;
            //     Promoted = true;
            //     PromotedCategory = "Report";
            //     PromotedIsBig = true;


            //     trigger OnAction();
            //     var
            //         lRecPurchTax: Record "ID Purch. Tax Mgmt";
            //     begin
            //         //mlf-DIS1.0
            //         lRecPurchTax.COPYFILTERS(Rec);
            //         IF lRecPurchTax.FINDFIRST THEN REPORT.RUN(Report::"Purchase - Credit Memo", TRUE, TRUE, lRecPurchTax);
            //         //mlf-DIS1.0
            //     end;
            // }
            // action("Export Retur Pajak Masukan")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export E-Faktur Retur';
            //     Image = ExportToExcel;
            //     Promoted = true;
            //     PromotedCategory = "Report";
            //     PromotedIsBig = true;

            //     //RunObject = report "Retur Pajak Keluaran";
            //     trigger OnAction();
            //     var
            //         lRecPurchTax: Record "ID Purch. Tax Mgmt";
            //     begin
            //         //mlf-DIS1.0
            //         lRecPurchTax.COPYFILTERS(Rec);
            //         IF lRecPurchTax.FINDFIRST THEN REPORT.RUN(Report::"Payments on Hold", TRUE, TRUE, lRecPurchTax);
            //         //mlf-DIS1.0
            //     end;
            // }
            action("Edit Tax Information")
            {
                ApplicationArea = All;
                Image = Edit;
                RunObject = page "Edit Pajak Masukan";
                RunPageLink = "No." = field("No.");
            }
            action(Validate)
            {
                ApplicationArea = All;
                Caption = 'Validate Faktur Pajak';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostedPOInvoice: Option;
                begin
                    // Memeriksa apakah beberapa field sudah terisi
                    if (Rec."Tax No." = '') then
                        Error('Tax No. harus diisi.');

                    if (Rec."Buy-from Vendor No." = '') then
                        Error('Buy-from Vendor No. harus diisi.');

                    if (Rec."VAT Registration No." = '') then
                        Error('VAT Registration No. harus diisi.');

                    if (Rec.Amount = 0) then
                        Error('Amount tidak boleh 0.');


                    // Jika semua field sudah terisi, lanjutkan validasi
                    Rec.Validasi := true; // Set True jika validasi berhasil
                    Rec.Modify(); // Simpan perubahan
                    CurrPage.Update(); // Update tampilan halaman setelah validasi
                end;
            }
            action(Unvalidate)
            {
                ApplicationArea = All;
                Caption = 'Unvalidate Faktur Pajak';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    UserSecurity: Codeunit "User Setup Management";
                    IsAdmin: Boolean;
                begin
                    // Cek apakah user memiliki role Admin
                    // IsAdmin := UserSecurity.HasRole('Business manager', USERID);
                    // if not IsAdmin then begin
                    //     Message('Hanya Admin yang bisa melakukan Unvalidate.');
                    //     exit;
                    // end;

                    // Memeriksa apakah faktur sudah divalidasi
                    if Rec.Validasi then begin
                        Rec.Validasi := false; // Batalkan validasi
                        Rec.Modify(); // Simpan perubahan
                        Message('Berhasil Validasi Document No %1', rec."No.");//Pesan Berhasil di validasi
                        CurrPage.Update(); // Update tampilan halaman setelah unvalidate
                    end;
                end;
            }
            // action("Export to CSV")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Caption = 'Export to CSV3';

            //     trigger OnAction()
            //     var
            //         PurchTaxRec: Record "ID Purch. Tax Mgmt";
            //         FileWriter: OutStream;
            //         FileReader: InStream;
            //         TempBlob: Codeunit "Temp Blob";
            //         FileName: Text;
            //         MimeType: Text;
            //         CsvLine: Text;
            //         FK: TEXT;
            //         FG: TEXT;
            //         MP: Text;
            //     begin
            //         if (rec."Tax No." = '') then
            //             Error('Please fill Faktur Pajak No. and try again');
            //         // Tentukan nama file CSV
            //         FileName := 'PurchTaxExport.csv';
            //         MimeType := 'text/csv';

            //         // Buat temp blob untuk menyimpan file CSV sementara
            //         TempBlob.CreateOutStream(FileWriter);

            //         // Tulis header CSV
            //         CsvLine := 'FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN;JUMLAH_PPNBM;ID_KETERANGAN_TAMBAHAN;FG_UANG_MUKA;UANG_MUKA_DPP;UANG_MUKA_PPN;UANG_MUKA_PPNBM;REFERENSI;KODE_DOKUMEN_PENDUKUNG;LT;NPWP;NAMA;JALAN;BLOK;NOMOR;RT;RW;KECAMATAN;KELURAHAN;KABUPATEN;PROPINSI;KODE_POS;NOMOR_TELEPON;OF;KODE_OBJEK;NAMA;HARGA_SATUAN;JUMLAH_BARANG;HARGA_TOTAL;DISKON;DPP;PPN;TARIF_PPNBM;PPNBM';
            //         FileWriter.WriteText(CsvLine);

            //         // Loop untuk setiap record di tabel "ID Purch. Tax Mgmt"
            //         PurchTaxRec.CopyFilters(Rec); // Salin filter dari halaman yang aktif
            //         if PurchTaxRec.FindSet() then
            //             repeat
            //                 // Format setiap baris data CSV
            //                 CsvLine :=
            //                     'FK;' +
            //                     Format(PurchTaxRec."Transaction Code") + ';' +
            //                     Format(FG) + '6;' +
            //                     Format(PurchTaxRec."Tax No.") + ';' +
            //                     Format(PurchTaxRec."Tahun Pajak") + ';' +
            //                     Format(PurchTaxRec."Posting Date", 0, '<Day,2>/<Month,2>/<Year,4>') + ';' +
            //                     Format(PurchTaxRec."VAT Registration No.") + ';' +
            //                     Format(PurchTaxRec."Buy-from Vendor Name") + ';' +
            //                     Format(PurchTaxRec."NPWP Address") + ';' +
            //                     Format(PurchTaxRec.Amount) + ';' +
            //                     //Format(PurchTaxRec."Amount Incl. VAT") + ';' +
            //                     //Format(PurchTaxRec."VAT Amount") + ';' +
            //                     Format(PurchTaxRec."Your Reference") + ';' +
            //                     Format(PurchTaxRec."Transaction Code");

            //                 // Tulis baris ke dalam file CSV
            //                 FileWriter.WriteText(CsvLine);

            //             until PurchTaxRec.Next() = 0;

            //         // Setelah selesai menulis ke OutStream, buat InStream dari TempBlob
            //         TempBlob.CreateInStream(FileReader);

            //         // Unduh file CSV ke sistem pengguna menggunakan InStream
            //         DownloadFromStream(FileReader, '', '', FileName, MimeType);
            //         Message('CSV File successfully exported');
            //     end;
            // }

            // action("Export to CSV1")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Caption = 'Export to CSV';

            //     trigger OnAction()
            //     var
            //         PurchTaxRec: Record "ID Purch. Tax Mgmt";
            //         FileWriter: OutStream;
            //         FileReader: InStream;
            //         TempBlob: Codeunit "Temp Blob";
            //         FileName: Text;
            //         MimeType: Text;
            //         CsvLine: Text;
            //     begin
            //         // Tentukan nama file CSV
            //         FileName := 'PurchTaxExport.csv';
            //         MimeType := 'text/csv';

            //         // Salin filter dari halaman saat ini
            //         PurchTaxRec.CopyFilters(Rec);

            //         // Cek jika ada data yang terfilter
            //         IF PurchTaxRec.FINDSET() THEN BEGIN
            //             // Buat temp blob untuk menyimpan file CSV sementara
            //             TempBlob.CreateOutStream(FileWriter);

            //             // Tulis header CSV
            //             CsvLine := 'FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN';
            //             FileWriter.WriteText(CsvLine);

            //             // Proses setiap record yang terfilter
            //             REPEAT
            //                 // Format setiap baris data CSV
            //                 CsvLine := Format(PurchTaxRec."Transaction Code") + ';' +
            //                            Format(PurchTaxRec."Tax No.") + ';' +
            //                            Format(PurchTaxRec."Tahun Pajak") + ';' +
            //                            Format(PurchTaxRec."Posting Date", 0, '<Day,2>/<Month,2>/<Year,4>') + ';' +
            //                            Format(PurchTaxRec."VAT Registration No.") + ';' +
            //                            Format(PurchTaxRec.Amount);

            //                 // Tulis baris ke dalam file CSV
            //                 FileWriter.WriteText(CsvLine);

            //             UNTIL PurchTaxRec.NEXT = 0;

            //             // Setelah selesai menulis ke OutStream, buat InStream dari TempBlob
            //             TempBlob.CreateInStream(FileReader);

            //             // Unduh file CSV ke sistem pengguna menggunakan InStream
            //             DownloadFromStream(FileReader, '', '', FileName, MimeType);
            //             Message('CSV File successfully exported');
            //         END ELSE BEGIN
            //             Message('No data available for export.');
            //         END;
            //     end;
            // }
            action("Export to CSV2")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Export to CSV selection';

                trigger OnAction()
                var
                    SelectedRecords: Record "ID Purch. Tax Mgmt";
                    FileWriter: OutStream;
                    FileReader: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    FileName: Text;
                    MimeType: Text;
                    CsvLine: Text;
                    FK: Text;
                    FGP: Text;
                    MP: Text;
                    LT: Text;
                    Txtbuilder: TextBuilder;
                    OFF: Text;

                begin
                    // Mengambil record yang dipilih dari halaman
                    CurrPage.SETSELECTIONFILTER(SelectedRecords);

                    // Cek jika ada data yang dipilih
                    IF SelectedRecords.FINDSET() THEN BEGIN
                        // Tentukan nama file CSV
                        FileName := 'PajakMasukkan' + Format(CurrentDateTime) + '.csv';
                        MimeType := 'text/csv';

                        // Buat temp blob untuk menyimpan file CSV sementara
                        TempBlob.CreateOutStream(FileWriter);

                        // Tulis header CSV
                        CsvLine := 'FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN;JUMLAH_PPNBM;ID_KETERANGAN_TAMBAHAN;FG_UANG_MUKA;UANG_MUKA_DPP;UANG_MUKA_PPN;UANG_MUKA_PPNBM;REFERENSI;KODE_DOKUMEN_PENDUKUNG' + ';LT;NPWP;NAMA;JALAN;BLOK;NOMOR;RT;RW;KECAMATAN;KELURAHAN;KABUPATEN;PROPINSI;KODE_POS;NOMOR_TELEPON' + ';OF;KODE_OBJEK;NAMA;HARGA_SATUAN;JUMLAH_BARANG;HARGA_TOTAL;DISKON;DPP;PPN;TARIF_PPNBM;PPNBM';
                        FileWriter.WriteText(CsvLine);

                        // Proses setiap record yang dipilih
                        REPEAT
                            CsvLine := Format(FK) + 'FK;' +
                                Format(SelectedRecords."Transaction Code") + ';' +
                                Format(FGP) + '6' +
                                Format(SelectedRecords."Tax No.") + ';' +
                                Format(MP) + '6' +
                                Format(SelectedRecords."Tahun Pajak") + ';' +
                                Format(SelectedRecords."Posting Date") + ';' +
                                Format(SelectedRecords."NPWP No.1") + ';' +
                                Format(SelectedRecords."NPWP Name") + ';' +
                                Format(SelectedRecords."Pay-to Address") + ';' +
                                Format(SelectedRecords.Amount) + ';' +
                                Format(SelectedRecords."Prices Including VAT") + ';' +
                                Format(SelectedRecords.Amount) + ';' +
                                Format(SelectedRecords."Additional Notes") + ';' +
                                Format(SelectedRecords."Prepayment Invoice") + ';' +
                                Format(SelectedRecords."Amount Prepayment PPN") + ';' +
                                Format(SelectedRecords."Amount Prepayment DPP") + ';' +
                                Format(SelectedRecords."Amount Prepayment PPNBM") + ';' +
                                Format(SelectedRecords."Your Reference") + ';' +
                                Format(SelectedRecords."Document No") + ';' +
                                Format(LT) + 'LT;' +
                                Format(SelectedRecords."NPWP No.1") + ';' +
                                Format(SelectedRecords."NPWP Name") + ';' +
                                Format(SelectedRecords."Buy-from Vendor Name") + ';' +
                                Format(SelectedRecords."Buy-from Address") + ';' +
                                Format(SelectedRecords."Buy-from Address 2") + ';' +
                                Format(SelectedRecords."Buy-from City") + ';' +
                                Format(SelectedRecords."Buy-from Post Code") + ';' +
                                Format(SelectedRecords."Buy-from Contact No.");

                            // Tulis baris ke dalam file CSV
                            FileWriter.WriteText(CsvLine);
                        UNTIL SelectedRecords.NEXT = 0;

                        // Setelah selesai menulis ke OutStream, buat InStream dari TempBlob
                        TempBlob.CreateInStream(FileReader);

                        // Unduh file CSV ke sistem pengguna menggunakan InStream
                        DownloadFromStream(FileReader, '', '', '', FileName);
                        Message('CSV File successfully exported');
                    END ELSE BEGIN
                        Message('No records selected for export.');
                    END;
                end;
            }

            action("Export Csv")
            {
                ApplicationArea = all;
                Caption = 'New Export Csv1';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;



                trigger OnAction()
                var
                    ins: InStream;
                    out: OutStream;
                    tempBlob: Codeunit "Temp Blob";
                    TxtBuilder: TextBuilder;
                    filename: Text;
                    SelectedRecords: Record "ID Purch. Tax Mgmt";
                    FGP: Text;
                    MP: Text;
                    LT: Text;





                begin

                    // Mengambil record yang dipilih dari halaman
                    CurrPage.SETSELECTIONFILTER(SelectedRecords);

                    IF SelectedRecords.FINDSET() THEN BEGIN

                        if (Rec."Tax No." = '') then
                            Error('Please fill Faktur Pajak No. and try again');

                        //File Name Csv
                        filename := 'Pajak_Masukkan' + Format(CurrentDateTime) + '.csv';

                        //Header CSV
                        TxtBuilder.AppendLine('FM' + ';' + 'KD_JENIS_TRANSAKSI' + ';' + 'FG_PENGGANTI' + ';' + 'NOMOR_FAKTUR' + ';' + 'MASA_PAJAK' + ';' + 'TAHUN_PAJAK' + ';' + 'TANGGAL_FAKTUR' + ';' + 'NPWP' + ';' + 'NAMA' + ';' + 'ALAMAT_LENGKAP' + ';' + 'JUMLAH_DPP' + ';' + 'JUMLAH_PPN' + ';' + 'JUMLAH_PPNBM' + ';' + 'ID_KETERANGAN_TAMBAHAN' + ';' + 'FG_UANG_MUKA' + ';' + 'UANG_MUKA_DPP' + ';' + 'UANG_MUKA_PPN' + ';' + 'UANG_MUKA_PPNBM' + ';' + 'REFERENSI' + ';' + 'KODE_DOKUMEN_PENDUKUNG');

                        repeat
                            TxtBuilder.AppendLine('FM' + ';' + AddFormatLine(Format(SelectedRecords."Transaction Code")) + ';' + '6' + ';' + AddFormatLine(Format(SelectedRecords."Tax No.")) + ';' + '2024' + ';' + '2024' + ';' + AddFormatLine(Format(SelectedRecords."Posting Date")) + ';' + AddFormatLine(Format(SelectedRecords."NPWP No.1")) + ';' + AddFormatLine(Format(SelectedRecords."Buy-from Vendor Name", 0, 9)) + ';' + AddFormatLine(Format(SelectedRecords."Buy-from Address")) + ';' + AddFormatLine(Format(gdecDocAmount, 0, 9)) + ';' + '0' + ';' + '0' + ';' + ';' + '0' + ';' + AddFormatLine(Format(SelectedRecords."Additional Notes")) + ';' + '0' + ';' + '0' + ';' + '0' + ';' + '0' + ';' + AddFormatLine(Format(SelectedRecords."Your Reference")) + AddFormatLine(Format(SelectedRecords."Additional Document No")));

                        UNTIL SelectedRecords.NEXT = 0;

                        TempBlob.CreateOutStream(out);
                        out.WriteText(Txtbuilder.ToText());
                        TempBlob.CreateInStream(ins);
                        DownloadFromStream(ins, '', '', '', FileName);

                    end
                end;

            }



        }
    }
    trigger OnAfterGetRecord();
    var
        lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
    begin
        gdecDocAmount := 0;
        gdecDocAmountInclVAT := 0;
        gdecDocAmountPrepayment := 0;
        lrecPurchTaxDoc.RESET();
        lrecPurchTaxDoc.SETRANGE("Document Type", Rec."Document Type");
        lrecPurchTaxDoc.SETRANGE("No.", Rec."No.");
        IF lrecPurchTaxDoc.FINDSET() THEN BEGIN
            lrecPurchTaxDoc.CALCFIELDS("Amount Invoice", "Amount Credit Memo", "Amount Incl. VAT Invoice", "Amount Incl. VAT Credit Memo");
            IF lrecPurchTaxDoc."Document Type" = lrecPurchTaxDoc."Document Type"::"Credit Memo" THEN BEGIN
                gdecDocAmount := (lrecPurchTaxDoc."Amount Invoice" + lrecPurchTaxDoc."Amount Credit Memo") * -1;
                gdecDocAmountInclVAT := (lrecPurchTaxDoc."Amount Incl. VAT Invoice" + lrecPurchTaxDoc."Amount Incl. VAT Credit Memo") * -1;

            END
            ELSE BEGIN
                gdecDocAmount := lrecPurchTaxDoc."Amount Invoice" + lrecPurchTaxDoc."Amount Credit Memo";
                gdecDocAmountInclVAT := lrecPurchTaxDoc."Amount Incl. VAT Invoice" + lrecPurchTaxDoc."Amount Incl. VAT Credit Memo";
            END;
        END;
        Rec.CalcFields(Amount, "Amount Including VAT");
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;

        //Menambahkan Line number
        // if not LineNumberCalculated then begin
        //     LineCounter := LineCounter + 1;
        //     Rec."Line Number" := LineCounter;
        //     Rec.Modify(); // Simpan perubahan LineNumber ke record
        // end;

    end;

    trigger OnOpenPage();
    var
        linecounter: Integer;
        PurchTaxRecord: Record "ID Purch. Tax Mgmt";
    begin
        fUpdateData();
        //Reset Nomor Line Number
        // LineCounter := 0;
        // LineNumberCalculated := false;
        LineCounter := 0; // Reset LineCounter

        // Ambil semua record dari tabel dan urutkan berdasarkan Document No.
        PurchTaxRecord.RESET();
        PurchTaxRecord.SETCURRENTKEY("No."); // Pastikan record diurutkan berdasarkan Document No.
        if PurchTaxRecord.FINDFIRST then begin
            repeat
                LineCounter := LineCounter + 1; // Tambah LineCounter untuk setiap record
                PurchTaxRecord."Line Number" := LineCounter;
                PurchTaxRecord.MODIFY(); // Simpan perubahan Line Number
            until PurchTaxRecord.NEXT = 0;
        end;

        CurrPage.UPDATE(); // Refresh halaman untuk menampilkan perubahan

    end;

    var

        LineNumberCalculated: Boolean;
        inititialized: Boolean;
        linenumber: Integer;
        gOptDocType: Option Invoice,"Credit Memo";
        gboolActivateFilter: Boolean;
        gboolCanceledDoc: Boolean;
        gboolCalc0VAT: Boolean;
        gBoolCanceled: Boolean;
        gcodeDocNo: Code[30];
        gcodeTaxNo: Code[30];
        gcodeVendorNo: Code[30];
        gdecTotalAmount: Decimal;
        gdecTotalAmountInclVAT: Decimal;
        gdecDocAmount: Decimal;
        gdecDocAmountInclVAT: Decimal;
        VATAMount: Decimal;
        gdecDocAmountPrepayment: Decimal;

    local procedure fUpdateData();
    begin
        Rec.RESET;
        IF gboolActivateFilter THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Document Type", gOptDocType);
            IF gcodeVendorNo <> '' THEN Rec.SETFILTER("Buy-from Vendor No.", gcodeVendorNo);
            IF gcodeTaxNo <> '' THEN Rec.SETFILTER("Tax No.", gcodeTaxNo);
            IF gcodeDocNo <> '' THEN Rec.SETFILTER("No.", gcodeDocNo);
            Rec.FILTERGROUP(0);
        END;
        fCalculateTotal();
        CurrPage.UPDATE(FALSE);
    end;

    local procedure fUpdatePurchInvHeader(pcodeDocNo: Code[30]; pcodeTaxNo: Code[30]);
    var
        lrecPurchInvHeader: Record "Purch. Inv. Header";
    begin
        lrecPurchInvHeader.RESET();
        lrecPurchInvHeader.SETFILTER("No.", pcodeDocNo);
        IF lrecPurchInvHeader.FINDSET() THEN BEGIN
            //lrecSalesInvHeader."Tax No.":=pcodeTaxNo;
            //lrecSalesInvHeader.MODIFY();
        END;
    end;

    local procedure fCalculateTotal();
    var
        lrecPurchTaxDoc: Record "ID Purch. Tax Mgmt";
    begin
        gdecTotalAmount := 0;
        gdecTotalAmountInclVAT := 0;
        lrecPurchTaxDoc.RESET();
        IF gboolActivateFilter THEN BEGIN
            lrecPurchTaxDoc.SETRANGE("Document Type", gOptDocType);
            //SETRANGE("Cancelled Tax",gBoolCanceled);
            //SETRANGE(Cancelled,gboolCanceledDoc);
            IF gcodeVendorNo <> '' THEN lrecPurchTaxDoc.SETFILTER("Sell-to Customer No.", gcodeVendorNo);
            IF gcodeTaxNo <> '' THEN lrecPurchTaxDoc.SETFILTER("Tax No.", gcodeTaxNo);
            IF gcodeDocNo <> '' THEN lrecPurchTaxDoc.SETFILTER("No.", gcodeDocNo);
        END;
        IF lrecPurchTaxDoc.FINDSET() THEN
            REPEAT
                lrecPurchTaxDoc.CALCFIELDS("Amount Invoice", "Amount Credit Memo", "Amount Incl. VAT Invoice", "Amount Incl. VAT Credit Memo");
                IF lrecPurchTaxDoc."Document Type" = lrecPurchTaxDoc."Document Type"::Invoice THEN BEGIN
                    gdecTotalAmount := gdecTotalAmount + (lrecPurchTaxDoc."Amount Invoice" + lrecPurchTaxDoc."Amount Credit Memo");
                    gdecTotalAmountInclVAT := gdecTotalAmountInclVAT + (lrecPurchTaxDoc."Amount Incl. VAT Invoice" + lrecPurchTaxDoc."Amount Incl. VAT Credit Memo");
                END
                ELSE BEGIN
                    gdecTotalAmount := gdecTotalAmount + ((lrecPurchTaxDoc."Amount Invoice" + lrecPurchTaxDoc."Amount Credit Memo") * -1);
                    gdecTotalAmountInclVAT := gdecTotalAmountInclVAT + ((lrecPurchTaxDoc."Amount Incl. VAT Invoice" + lrecPurchTaxDoc."Amount Incl. VAT Credit Memo") * -1);
                END;
            UNTIL lrecPurchTaxDoc.NEXT = 0;
    end;

    local procedure AddFormatLine(FieldValue: Text): Text
    begin
        exit('"' + FieldValue + '"');
    end;

    // local procedure addFormatdecline(fieldvalue: Decimal): Decimal
    // begin
    //     exit(fieldvalue)
    // end;
}
