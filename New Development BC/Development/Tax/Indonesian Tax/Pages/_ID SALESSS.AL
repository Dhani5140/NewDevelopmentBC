page 80222 "ID Sales Tax Document Mgmt"
{
    PageType = List;
    SourceTable = "ID Sales Tax Mgmt1";
    SourceTableView = where("VAT PERCENT1" = filter('>0'));
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;
    Caption = 'Pajak Keluaran';
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Pick; Rec.Pick)
                {
                    ApplicationArea = All;
                    Caption = 'Pick';
                    Editable = edit;

                    trigger OnValidate()
                    begin
                        if Rec.Pick and (Rec."Pick Date" = 0D) then begin
                            Rec."Pick Date" := TODAY;
                        end else if not Rec.Pick then begin
                            Rec."Pick Date" := 0D;
                        end;
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                field("Pick Date"; Rec."Pick Date")
                {
                    ApplicationArea = All;
                    Caption = 'Pick Date';
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    Editable = false;
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;
                }
                field("Faktur Date"; Rec."Faktur Date")
                {
                    ApplicationArea = all;

                }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                    Caption = 'Faktur Pajak No.';
                    Editable = false;
                }

                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    Editable = false;
                }
                // field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                // {
                //     ApplicationArea = all;
                //     Caption = 'Customer Name';
                //     Editable = false;

                // }
                field("Sell-to Customer Name1"; Rec."Sell-to Customer Name1")
                {
                    ApplicationArea = all;
                    Caption = 'Customer name';
                    Editable = false;
                }

                // field("Transaction Code"; Rec."Transaction Code")
                // {
                //     ApplicationArea = ALL;
                // }
                field("Transaction Code1"; Rec."Transaction Code1")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Branch Code1"; Rec."Branch Code1")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = ALL;
                }
                // field("NPWP No."; Rec."NPWP No.")
                // {
                //     ApplicationArea = ALL;
                //     Editable = false;
                // }
                field("NPWP No.1"; Rec."NPWP No.1")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                    Caption = 'NPWP No.';
                }
                // field("NPWP Name."; Rec."NPWP Name.")
                // {
                //     ApplicationArea = ALL;
                //     Editable = false;
                // }
                field("NPWP Name.1"; Rec."NPWP Name.1")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'NPWP Name';
                }
                // field("NPWP Address"; Rec."NPWP Address")
                // {
                //     ApplicationArea = ALL;
                //     Editable = false;
                // }
                field("NPWP Address1"; Rec."NPWP Address1")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'NPWP Address';
                }
                field("NPWP Address21"; Rec."NPWP Address21")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'NPWP Address 2';
                }


                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Editable = false;
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Editable = false;
                }

                field(VATAmount; VATAmount)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Amount PPNBM';
                }

                field("Amount Prepayment"; Rec."Amount Prepayment")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("Amount Prepayment DPP"; Rec."Amount Prepayment DPP")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("Amount Prepayment PPN"; Rec."Amount Prepayment PPN")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("Amount Prepayment PPNBM"; Rec."Amount Prepayment PPNBM")
                {
                    ApplicationArea = ALL;
                    Editable = false;
                }
                field("Additional Notes"; Rec."Additional Notes")
                {
                    ApplicationArea = ALL;
                }
                field(Reference; Rec.Reference)
                {
                    ApplicationArea = ALL;
                }

                field("Additional Document No."; Rec."Additional Document No.")
                {
                    ApplicationArea = all;
                }
                field(Exported; Rec.Exported)
                {
                    ApplicationArea = All;
                    Caption = 'Exported';
                    Editable = true;


                    trigger OnValidate()
                    begin
                        IF Rec.Exported AND (REC."Exported Date" = 0D) THEN begin
                            Rec."Exported Date" := Today;
                        end ELSE IF not Rec.Exported THEN begin
                            Rec."Exported Date" := 0D;
                        end;
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                field("Exported Date"; Rec."Exported Date")
                {
                    ApplicationArea = All;
                    Caption = 'Exported Date';
                    Editable = false;

                }
                field(validasi; Rec.validasi)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Apply Doc"; Rec."Apply Doc")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Amount PPNBM"; Rec."Amount PPNBM")
                {
                    ApplicationArea = all;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        rec."Amount PPNBM" := rec.Amount - rec."Amount Including VAT";
                    end;
                }
                // field("Is Valid"; "Is Valid")
                // {
                //     ApplicationArea = all;
                // }
                field("VAT PERCENT"; rec."VAT PERCENT")
                {
                    ApplicationArea = ALL;
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
                Caption = 'Pick All';

                trigger OnAction();
                var
                    lrecSalesTaxDoc: Record "ID Sales Tax Mgmt1";
                begin
                    lrecSalesTaxDoc.CopyFilters(Rec);
                    IF lrecSalesTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecSalesTaxDoc.Pick := TRUE;
                            lrecSalesTaxDoc.MODIFY();
                        UNTIL lrecSalesTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }

            action("Unpick All")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Unpick All';

                trigger OnAction();
                var
                    lrecSalesTaxDoc: Record "ID Sales Tax Mgmt1";
                begin
                    lrecSalesTaxDoc.CopyFilters(Rec);
                    IF lrecSalesTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecSalesTaxDoc.Pick := FALSE;
                            lrecSalesTaxDoc.MODIFY();
                        UNTIL lrecSalesTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Filter PPNBM > 0")
            {
                ApplicationArea = All;
                Caption = 'Filter PPNBM > 0';

                trigger OnAction()
                begin
                    // Set filter Amount PPNBM lebih dari 0
                    Rec.SetFilter("Amount PPNBM", '>0');
                    CurrPage.Update();
                end;
            }

            action("Clear Filters")
            {
                ApplicationArea = All;
                Caption = 'Clear Filters';

                trigger OnAction()
                begin
                    // Hapus semua filter
                    Rec.Reset();
                    CurrPage.Update();
                end;
            }
            action("Assign Faktur Pajak From Picked2")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Assign Faktur Pajak From Picked';

                trigger OnAction();
                var
                    viewGenerateLine: Record "Table View Generate Line2";
                    salesTaxRec: Record "ID Sales Tax Mgmt1";
                    Postedsales: Record "Sales Invoice Header";
                    viewGenerateHeader: Record "Generate Pajak Table2"; // Tabel tempat mengambil Year
                    fakturno: Code[20];
                    fakturapply: Code[20];
                    assignedCount: Integer;
                    yearCode: Code[10];
                    transCode: Option;
                begin
                    // Filter Faktur Pajak yang belum terpakai (Status = Free)
                    viewGenerateLine.SetRange(Status, viewGenerateLine.Status::Free);
                    viewGenerateLine.SetRange("Branch Code", Rec."Branch Code1");
                    viewGenerateLine.SetRange("Transaction Code", Rec."Transaction Code1");
                    viewGenerateLine.SetFilter("Faktur Pajak No", '<>%1', ''); // Faktur Pajak yang tidak kosong

                    // Memulai penghitung
                    assignedCount := 0;

                    // Memastikan record yang di-pick
                    if Rec.FindSet() then begin
                        repeat
                            // Cek apakah record dipick dan Tax No belum diisi untuk baris ini
                            if Rec.Pick and (Rec."Tax No." = '') then begin
                                // Ambil nomor faktur pajak dari View Generate Pajak
                                if viewGenerateLine.FindFirst() then begin
                                    fakturno := viewGenerateLine."Faktur Pajak No";
                                    fakturapply := viewGenerateLine."Document No.";

                                    // Cari record dari Generate Pajak Header untuk mengambil nilai Year
                                    if viewGenerateHeader.Get(viewGenerateLine."Document No.") then begin
                                        yearCode := viewGenerateHeader.Year; // Ambil nilai Year dari tabel Generate Pajak
                                    end;

                                    //Assign record Transaction Code di posted sales invoice
                                    Postedsales.SetRange("No.", Rec."No.");
                                    if Postedsales.FindFirst() then begin
                                        transCode := Postedsales."Transaction Code";

                                    end;

                                    // Assign nomor faktur pajak ke Sales Tax Record
                                    salesTaxRec.SetRange("No.", Rec."No.");

                                    if salesTaxRec.FindFirst() then begin
                                        salesTaxRec."Tax No." := fakturno;
                                        salesTaxRec."Apply Doc" := fakturapply;
                                        //salesTaxRec."Transaction Code" := transCode;
                                        salesTaxRec.validasi := true;
                                        // Isi Faktur Date dengan tanggal hari ini
                                        salesTaxRec."Faktur Date" := Today;
                                        salesTaxRec."Tahun Pajak" := yearCode; // Assign Year ke field di Sales Tax
                                        salesTaxRec.Modify();

                                        // Update status faktur pajak jadi Used
                                        viewGenerateLine.Status := viewGenerateLine.Status::Used;
                                        viewGenerateLine."Document No1" := Rec."No.";
                                        viewGenerateLine."Bill-to / Pay-To No." := Rec."No.";
                                        viewGenerateLine.Modify();

                                        // Update penghitung
                                        assignedCount += 1;
                                    end;
                                end else
                                    break; // Tidak ada faktur pajak yang tersedia
                            end;
                        until Rec.NEXT = 0;

                        // Tampilkan pesan hasil
                        if assignedCount > 0 then
                            Message('%1 Faktur Pajak berhasil diassign.', assignedCount)
                        else
                            Error('Tidak ada Faktur Pajak yang tersedia untuk diassign.');
                    end;
                end;
            }
            // action("Export to CSV")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Caption = 'Export to CSV';

            //     trigger OnAction()
            //     var
            //         salesTaxRec: Record "ID Sales Tax Mgmt1";
            //         FileWriter: OutStream;
            //         FileReader: InStream;
            //         TempBlob: Codeunit "Temp Blob";
            //         FileName: Text;
            //         MimeType: Text;
            //         CsvLine: Text;
            //         CsvLine2: Text;
            //         CsvLine3: Text;

            //     begin
            //         IF (Rec."Tax No." = '') then
            //             Error('Please fill Faktur Pajak No. and try again');
            //         // Tentukan nama file CSV
            //         FileName := 'PajakKeluaran_' + Format(CurrentDateTime) + '.csv';
            //         MimeType := 'text/csv';

            //         // Buat temp blob untuk menyimpan file CSV sementara
            //         TempBlob.CreateOutStream(FileWriter);

            //         // Tulis header CSV
            //         //CsvLine x:= 'FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN;JUMLAH_PPNBM;ID_KETERANGAN_TAMBAHAN;FG_UANG_MUKA;UANG_MUKA_DPP;UANG_MUKA_PPN;UANG_MUKA_PPNBM;REFERENSI;KODE_DOKUMEN_PENDUKUNG;LT;NPWP;NAMA;JALAN;BLOK;NOMOR;RT;RW;KECAMATAN;KELURAHAN;KABUPATEN;PROPINSI;KODE_POS;NOMOR_TELEPON;OF;KODE_OBJEK;NAMA;HARGA_SATUAN;JUMLAH_BARANG;HARGA_TOTAL;DISKON;DPP;PPN;TARIF_PPNBM;PPNBM';
            //         //CsvLine := 'No.Document Type,Customer No.,Customer Name,Tax No.,Amount,Amount Including VAT,Pick,Pick Date';
            //         CsvLine := 'FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN;JUMLAH_PPNBM;ID_KETERANGAN_TAMBAHAN;FG_UANG_MUKA;UANG_MUKA_DPP;UANG_MUKA_PPN;UANG_MUKA_PPNBM;REFERENSI;KODE_DOKUMEN_PENDUKUNG';
            //         FileWriter.WriteText(CsvLine);



            //         // Loop untuk setiap record di tabel "ID Sales Tax Mgmt1"
            //         salesTaxRec.SetRange("No.", Rec."No.");
            //         if salesTaxRec.FindFirst() then
            //             repeat
            //                 // Format setiap baris data CSV
            //                 CsvLine :=
            //                     Format('FK') + ';' +
            //                     Format(salesTaxRec."Transaction Code") + ';' +
            //                     Format('6') + ';' +
            //                     Format(salesTaxRec."No.") + ',' +
            //                     Format(salesTaxRec."Document Type") + ',' +
            //                     Format(salesTaxRec."Sell-to Customer No.") + ',' +
            //                     Format(salesTaxRec."Sell-to Customer Name") + ',' +
            //                     Format(salesTaxRec."Tax No.") + ',' +
            //                     Format(salesTaxRec.Amount) + ',' +
            //                     Format(salesTaxRec."Amount Including VAT") + ',' +
            //                     Format(salesTaxRec.Pick) + ',' +
            //                     Format(salesTaxRec."Pick Date");
            //                 FileWriter.WriteText(CsvLine);
            //             until salesTaxRec.Next() = 0;





            //         // Setelah selesai menulis ke OutStream, buat InStream dari TempBlob
            //         TempBlob.CreateInStream(FileReader);

            //         // Unduh file CSV ke sistem pengguna menggunakan InStream
            //         DownloadFromStream(FileReader, '', '', '', FileName);
            //         salesTaxRec.Exported := true;
            //         salesTaxRec.Modify();


            //         Message('CSV File successfully exported');
            //     end;
            // }

            action("Export Csv2")
            {
                ApplicationArea = all;
                Caption = 'New Export Csv2';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ins: InStream;
                    out: OutStream;
                    TempBlob: Codeunit "Temp Blob";
                    TxtBuilder: TextBuilder;
                    Filename: Text;
                    SelectedRecords: Record "ID Sales Tax Mgmt1";

                begin

                    IF (Rec."Tax No." = '') then
                        Error('Please fill Faktur Pajak No. and try again');
                    // Set Export Date ke hari ini sebelum export
                    Rec."Exported Date" := Today;
                    Rec.Modify(); // Simpan perubahan ke database

                    Filename := 'Pajak_Keluaran' + Format(CurrentDateTime) + '.csv';

                    SelectedRecords.SetRange("No.", Rec."No.");
                    IF SelectedRecords.FindFirst() then
                        //Header CSV
                    TxtBuilder.AppendLine('FK;KD_JENIS_TRANSAKSI;FG_PENGGANTI;NOMOR_FAKTUR;MASA_PAJAK;TAHUN_PAJAK;TANGGAL_FAKTUR;NPWP;NAMA;ALAMAT_LENGKAP;JUMLAH_DPP;JUMLAH_PPN;JUMLAH_PPNBM;ID_KETERANGAN_TAMBAHAN;FG_UANG_MUKA;UANG_MUKA_DPP;UANG_MUKA_PPN;UANG_MUKA_PPNBM;REFERENSI;KODE_DOKUMEN_PENDUKUNG');
                    TxtBuilder.AppendLine('LT;NPWP;NAMA;JALAN;BLOK;NOMOR;RT;RW;KECAMATAN;KELURAHAN;KABUPATEN;PROPINSI;KODE_POS;NOMOR_TELEPON');
                    TxtBuilder.AppendLine('OF;KODE_OBJEK;NAMA;HARGA_SATUAN;JUMLAH_BARANG;HARGA_TOTAL;DISKON;DPP;PPN;TARIF_PPNBM;PPNBM');

                    repeat
                        TxtBuilder.AppendLine('FK' + ';' + Format(SelectedRecords."Transaction Code") + ';' + '6' + ';' + Format(SelectedRecords."Tax No.") + ';' + '6' + ';' + Format(SelectedRecords."Faktur Date") + ';' + Format(SelectedRecords."NPWP No.1") + ';' + Format(SelectedRecords."NPWP Name.") + ';' + Format(SelectedRecords."NPWP Address") + ';' + ';PT UOB Kay Hian Sekuritas;UOB Plaza Thamrin Nine  Lt. 36 JL. MH Thamrin Kav. 8-10 Tanah Abang Jakarta Pusat DKI Jakarta Raya 10230;900000;99000;0;0;0;0;0;0;MCCINV/001/KPEI/0624;');
                        TxtBuilder.AppendLine('LT;017604000054000;Kliring Penjaminan Efek Indonesia;gedung bursa efek indonesia tower 1 lantai 5 jalan jend. sudirman kav 52-53 jakarta selatan 12190;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;555-555-0199@example.com;12190;555-555-0199');
                        TxtBuilder.AppendLine('OF;Biaya Administrasi Agunan;Biaya Administrasi Agunan;900000.00;1;900000.00;0.00;900000.00;99000;0;0.00');
                    until SelectedRecords.Next = 0;

                    TempBlob.CreateOutStream(out);
                    out.WriteText(Txtbuilder.ToText());
                    TempBlob.CreateInStream(ins);
                    DownloadFromStream(ins, '', '', '', Filename);

                end;

            }

            // action("Export Sales Tax Document")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Export Sales Tax Document';
            //     Promoted = true;
            //     PromotedCategory = Report;
            //     PromotedIsBig = true;
            //     Image = ExportToExcel;

            //     trigger OnAction();
            //     var
            //         lRecSalesTax: Record "ID Sales Tax Mgmt1";
            //     begin
            //         lRecSalesTax.COPYFILTERS(Rec);
            //         IF lRecSalesTax.FINDFIRST THEN
            //             REPORT.RUN(Report::"Sales - Credit Memo", TRUE, TRUE, lRecSalesTax);
            //     end;
            // }

            // action("Unassign Faktur Pajak")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Caption = 'Unassign Faktur Pajak';

            //     trigger OnAction();
            //     var
            //         salesTaxRec: Record "ID Sales Tax Mgmt1";
            //         viewGenerateLine: Record "Table View Generate Line2";
            //     begin
            //         // Cari record berdasarkan No. di page ID Sales Tax
            //         salesTaxRec.SetRange("No.", Rec."No.");
            //         if salesTaxRec.FindFirst() then begin
            //             // Cek apakah faktur pajak sudah diassign
            //             if salesTaxRec."Tax No." <> '' then begin
            //                 // Cari record faktur pajak di tabel "Table View Generate Line2"
            //                 viewGenerateLine.SetRange("Faktur Pajak No", salesTaxRec."Tax No.");
            //                 if viewGenerateLine.FindFirst() then begin
            //                     // Update status faktur pajak jadi Free
            //                     viewGenerateLine.Status := viewGenerateLine.Status::Free;
            //                     viewGenerateLine.Modify();

            //                     viewGenerateLine."Bill-to / Pay-To No." := Rec."No."; // Update dengan nomor dokumen yang sesuai
            //                     viewGenerateLine.Modify();


            //                     // Hapus nomor faktur pajak dari record Sales Tax
            //                     salesTaxRec."Tax No." := '';
            //                     salesTaxRec.Modify();

            //                     // Tampilkan pesan berhasil
            //                     Message('Faktur Pajak No. %1 berhasil di-unassign dari Document No. %2', viewGenerateLine."Faktur Pajak No", Rec."No.");
            //                 end else begin
            //                     Error('Faktur Pajak dengan No. %1 tidak ditemukan.', salesTaxRec."Tax No.");
            //                 end;
            //             end else begin
            //                 Error('Tidak ada Faktur Pajak yang diassign ke Document No. %1.', Rec."No.");
            //             end;
            //         end else begin
            //             Error('Document No. %1 tidak ditemukan.', Rec."No.");
            //         end;
            //     end;
            // }

            // action("Assign Faktur Pajak From Picked")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Caption = 'Assign Faktur Pajak From Picked';

            //     trigger OnAction();
            //     var
            //         viewGenerateLine: Record "Table View Generate Line2";
            //         salesTaxRec: Record "ID Sales Tax Mgmt1";
            //         viewGenerateHeader: Record "Generate Pajak Table2"; // Tabel tempat mengambil Year
            //         fakturno: Code[20];
            //         assignedCount: Integer;
            //         yearCode: Code[10];
            //     begin
            //         // Filter Faktur Pajak yang belum terpakai (Status = Free)
            //         viewGenerateLine.SetRange(Status, viewGenerateLine.Status::Free);
            //         viewGenerateLine.SetFilter("Faktur Pajak No", '<>%1', ''); // Faktur Pajak yang tidak kosong

            //         // Memulai penghitung
            //         assignedCount := 0;

            //         // Memastikan record yang di-pick
            //         if Rec.FindSet() then begin
            //             repeat
            //                 // Cek apakah record dipick dan Tax No belum diisi untuk baris ini
            //                 if Rec.Pick and (Rec."Tax No." = '') then begin
            //                     // Ambil nomor faktur pajak dari View Generate Pajak
            //                     if viewGenerateLine.FindFirst() then begin
            //                         fakturno := viewGenerateLine."Faktur Pajak No";

            //                         // Cari record dari Generate Pajak Header untuk mengambil nilai Year
            //                         if viewGenerateHeader.Get(viewGenerateLine."Document No.") then begin
            //                             yearCode := viewGenerateHeader.Year; // Ambil nilai Year dari tabel Generate Pajak
            //                         end;

            //                         // Assign nomor faktur pajak ke baris saat ini
            //                         salesTaxRec.SetRange("No.", Rec."No.");
            //                         if salesTaxRec.FindFirst() then begin
            //                             // Assign nomor faktur pajak dan Year
            //                             salesTaxRec."Tax No." := fakturno;
            //                             salesTaxRec."Tahun Pajak" := yearCode; // Assign Year ke field di Sales Tax
            //                             salesTaxRec.Modify();

            //                             // Update status faktur pajak jadi Used
            //                             viewGenerateLine.Status := viewGenerateLine.Status::Used;
            //                             viewGenerateLine.Modify();

            //                             // Update "Bill-to / Pay-To No." dengan nomor dokumen yang sesuai
            //                             viewGenerateLine."Bill-to / Pay-To No." := salesTaxRec."No."; // Assign document number
            //                             viewGenerateLine.Modify();

            //                             // Update penghitung
            //                             assignedCount += 1;
            //                         end;
            //                     end else
            //                         break; // Tidak ada faktur pajak yang tersedia
            //                 end;
            //             until Rec.NEXT = 0;

            //             // Tampilkan pesan hasil
            //             if assignedCount > 0 then
            //                 Message('%1 Faktur Pajak berhasil diassign dan status menjadi Used.', assignedCount)
            //             else
            //                 Error('Tidak ada Faktur Pajak yang tersedia untuk diassign.');
            //         end;
            //     end;
            // }



            action("Unassign Faktur Pajak2")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Unassign Faktur Pajak';

                trigger OnAction();
                var
                    salesTaxRec: Record "ID Sales Tax Mgmt1";
                    viewGenerateLine: Record "Table View Generate Line2";
                begin
                    // Cari record berdasarkan No. di page ID Sales Tax
                    salesTaxRec.SetRange("No.", Rec."No.");
                    if salesTaxRec.FindFirst() then begin
                        // Cek apakah faktur pajak sudah diassign
                        if salesTaxRec."Tax No." <> '' then begin
                            // Cari record faktur pajak di tabel "Table View Generate Line2"
                            viewGenerateLine.SetRange("Faktur Pajak No", salesTaxRec."Tax No.");
                            if viewGenerateLine.FindFirst() then begin
                                // Update status faktur pajak jadi Free
                                viewGenerateLine.Status := viewGenerateLine.Status::Free;
                                viewGenerateLine.Modify();

                                // Reset nomor dokumen di "Table View Generate Line2"
                                viewGenerateLine."Bill-to / Pay-To No." := ''; // Atau set ke nilai yang sesuai
                                viewGenerateLine."Document No1" := '';
                                viewGenerateLine.Modify();

                                // Hapus nomor faktur pajak dari record Sales Tax dan perubahan untuk status validasi
                                salesTaxRec."Tax No." := '';
                                salesTaxRec."Tahun Pajak" := '';
                                salesTaxRec."Faktur Date" := 0D;
                                salesTaxRec."Apply Doc" := '';
                                salesTaxRec."Transaction Code1" := 00;
                                salesTaxRec.Pick := false;
                                salesTaxRec."Pick Date" := 0D;
                                salesTaxRec.validasi := false;
                                salesTaxRec.Modify();

                                // Tampilkan pesan berhasil
                                Message('Faktur Pajak No. %1 berhasil di-unassign dari Document No. %2', salesTaxRec."Tax No.", Rec."No.");
                            end else begin
                                Error('Faktur Pajak dengan No. %1 tidak ditemukan.', salesTaxRec."Tax No.");
                            end;
                        end else begin
                            Error('Tidak ada Faktur Pajak yang diassign ke Document No. %1.', Rec."No.");
                        end;
                    end else begin
                        Error('Document No. %1 tidak ditemukan.', Rec."No.");
                    end;
                end;
            }


            // action("Assign Faktur Pajak From Generate Pajak")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Caption = 'Assign Faktur Pajak';

            //     trigger OnAction();
            //     var
            //         viewGenerateLine: Record "Table View Generate Line2";
            //         salesTaxRec: Record "ID Sales Tax Mgmt1";
            //         fakturno: Code[20];
            //         assignedCount: Integer;
            //     begin
            //         // Filter Faktur Pajak yang belum terpakai (Status = Free)
            //         viewGenerateLine.SetRange(Status, viewGenerateLine.Status::Free);
            //         viewGenerateLine.SetFilter("Faktur Pajak No", '<>%1', ''); // Faktur Pajak yang tidak kosong

            //         // Memulai penghitung
            //         assignedCount := 0;

            //         // Loop untuk setiap record yang dipilih
            //         if Rec.FindSet() then begin
            //             repeat
            //                 // Assign faktur pajak dari View Generate Pajak
            //                 if viewGenerateLine.FindFirst() then begin
            //                     fakturno := viewGenerateLine."Faktur Pajak No";

            //                     // Update record Sales Tax
            //                     salesTaxRec.SetRange("No.", Rec."No.");
            //                     if salesTaxRec.FindFirst() then begin
            //                         // Assign nomor faktur pajak
            //                         salesTaxRec."Tax No." := fakturno;
            //                         salesTaxRec.Modify();

            //                         // Update status faktur pajak jadi Used
            //                         viewGenerateLine.Status := viewGenerateLine.Status::Used;
            //                         viewGenerateLine.Modify();

            //                         // Update penghitung
            //                         assignedCount += 1;
            //                     end;
            //                 end else
            //                     break; // Tidak ada faktur pajak yang tersedia

            //             until Rec.NEXT = 0;

            //             // Tampilkan pesan
            //             if assignedCount > 0 then
            //                 Message('%1 Faktur Pajak berhasil diassign.', assignedCount)
            //             else
            //                 Error('Tidak ada Faktur Pajak yang tersedia untuk diassign.');
            //         end;
            //     end;
            // } 


            action("Assign Faktur Pajak From Picked21")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Cek Lookup Filter';

                trigger OnAction()
                var
                    FakturPajakLookup: Page "Faktur Pajak Lookup"; // Page lookup faktur pajak
                    viewGenerateLine: Record "Table View Generate Line2"; // Tabel faktur pajak
                    salesTaxRec: Record "ID Sales Tax Mgmt1"; // Tabel Sales Tax
                    fakturno: Code[20]; // Nomor faktur pajak yang akan diassign
                begin
                    // Set filter untuk page lookup berdasarkan Transaction Code dan Branch Code
                    viewGenerateLine.SetRange("Transaction Code", Rec."Transaction Code1");
                    viewGenerateLine.SetRange("Branch Code", Rec."Branch Code1");

                    // Tampilkan page lookup dengan filter yang sudah diterapkan
                    if PAGE.RunModal(52111, viewGenerateLine) = ACTION::None then begin
                        // Dapatkan faktur pajak yang dipilih dari page lookup
                        // viewGenerateLine.Get(viewGenerateLine."Faktur Pajak No");

                        // // Proses assign pajak
                        // fakturno := viewGenerateLine."Faktur Pajak No";

                        // Logika untuk memproses assign faktur pajak ke Sales Tax Record
                        if salesTaxRec.Get(Rec."No.") then begin
                            salesTaxRec.Validate("Tax No.", fakturno);
                            salesTaxRec.Validate("Faktur Date", Today);
                            salesTaxRec.validasi := true;
                            salesTaxRec.Modify();

                            // Update status faktur pajak
                            viewGenerateLine.Status := viewGenerateLine.Status::Used;
                            viewGenerateLine.Modify();

                            Message('Faktur Pajak %1 berhasil diassign.', fakturno);
                        end;
                    end;
                end;
            }

            action("Related")
            {
                ApplicationArea = all;
                Caption = 'Related Generated Faktur';
                Image = RelatedInformation;
                trigger OnAction()
                var
                    vw: Record "Table View Generate Header";
                begin
                    vw.SetRange("Faktur Pajak ID", rec."Apply Doc");
                    page.Run(page::"Page view Generate", vw);

                end;
            }



            // action("Export CSV Selection")
            // {
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Caption = 'Export To CSV Selection';
            //     trigger OnAction()
            //     var
            //     begin

            //     end;
            // }






        }
    }

    trigger OnOpenPage()
    var
        lrecSalesInvoice: Record "Sales Invoice Header";
        lrecSalesCreditMemo: Record "Sales Cr.Memo Header";
        lrecSalesTaxDoc: Record "ID Sales Tax Mgmt1";
        lrecsalesline: Record "Sales Invoice Line";
        TempRec: Record "ID Sales Tax Mgmt1";
    begin
        // Proses data dari Sales Invoice Header
        lrecSalesInvoice.Reset();
        if lrecSalesInvoice.FindSet() then
            repeat
                // Cek apakah record sudah ada di tabel Sales Tax Mgmt1
                if not lrecSalesTaxDoc.Get(lrecSalesTaxDoc."Document Type"::Invoice, lrecSalesInvoice."No.") then begin
                    lrecSalesTaxDoc.Init();
                    lrecSalesTaxDoc."Document Type" := lrecSalesTaxDoc."Document Type"::Invoice;
                    lrecSalesTaxDoc."No." := lrecSalesInvoice."No.";
                    lrecSalesTaxDoc."Sell-to Customer No." := lrecSalesInvoice."Sell-to Customer No.";
                    lrecSalesTaxDoc."Amount" := lrecSalesInvoice.Amount;
                    lrecSalesTaxDoc."Amount Including VAT" := lrecSalesInvoice."Amount Including VAT";
                    lrecSalesTaxDoc."Amount PPNBM" := lrecSalesInvoice."Amount Including VAT" - lrecSalesInvoice.Amount;


                    lrecSalesTaxDoc.Insert();
                end else begin
                    // Perbarui Amount PPNBM jika record sudah ada
                    lrecSalesTaxDoc."Amount PPNBM" := lrecSalesTaxDoc."Amount Including VAT" - lrecSalesTaxDoc.Amount;
                    lrecSalesTaxDoc.Modify();
                end;
            until lrecSalesInvoice.Next() = 0;

        // Proses data dari Sales Credit Memo Header
        lrecSalesCreditMemo.Reset();
        if lrecSalesCreditMemo.FindSet() then
            repeat
                // Cek apakah record sudah ada di tabel Sales Tax Mgmt1
                if not lrecSalesTaxDoc.Get(lrecSalesTaxDoc."Document Type"::"Credit Memo", lrecSalesCreditMemo."No.") then begin
                    lrecSalesTaxDoc.Init();
                    lrecSalesTaxDoc."Document Type" := lrecSalesTaxDoc."Document Type"::"Credit Memo";
                    lrecSalesTaxDoc."No." := lrecSalesCreditMemo."No.";
                    lrecSalesTaxDoc."Sell-to Customer No." := lrecSalesCreditMemo."Sell-to Customer No.";
                    lrecSalesTaxDoc."Amount" := lrecSalesCreditMemo.Amount;
                    lrecSalesTaxDoc."Amount Including VAT" := lrecSalesCreditMemo."Amount Including VAT";
                    lrecSalesTaxDoc."Amount PPNBM" := lrecSalesCreditMemo."Amount Including VAT" - lrecSalesCreditMemo.Amount;

                    lrecSalesTaxDoc.Insert();
                end else begin
                    // Perbarui Amount PPNBM jika record sudah ada
                    lrecSalesTaxDoc."Amount PPNBM" := lrecSalesTaxDoc."Amount Including VAT" - lrecSalesTaxDoc.Amount;
                    lrecSalesTaxDoc.Modify();
                end;
            until lrecSalesCreditMemo.Next() = 0;

        // Terapkan filter Amount PPNBM > 0


        // Pastikan halaman tidak error
        rec.SetFilter("VAT PERCENT1", '>0');
        CurrPage.Update();

        // // Validasi apakah filter diterapkan
        // TempRec.Copy(Rec);
        // if not TempRec.FindSet() then
        //     Message('Tidak ada record dengan Amount PPNBM > 0.');
    end;



    trigger OnAfterGetRecord()
    var
        HasVAT: Boolean; // Declare a local variable for dynamic calculation
    begin



        // Atur agar data hanya bisa diedit jika validasi belum diaktifkan
        if rec.validasi = true then
            editable := false
        else
            editable := true;

        // if rec."Amount PPNBM" <= 0 then
        //     CurrPage.Update(false);


        // Hitung nilai Amount PPNBM
        // Skip records where VAT is not applicable
        // Dynamically calculate "Has VAT" based on conditions
        //HasVAT := Rec."Amount Including VAT" > Rec.Amount;

        rec."Amount PPNBM" := rec."Amount Including VAT" - rec.Amount;
        // Skip the record if it doesn't meet the criteria
        if not HasVAT then
            CurrPage.SetRecord(Rec);

    end;








    var
        VATAmount: Decimal;
        edit: Boolean;

        TempPPNBM: Decimal;

}