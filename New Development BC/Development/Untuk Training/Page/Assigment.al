page 52223 AssignmentExamplePage
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = AssignmentExample;
    Caption = 'Assignment and Type Conversion Example';

    layout
    {
        area(content)
        {
            group("Assignment and Conversion")
            {
                field("Number1"; rec."Number1")
                {
                    ApplicationArea = All;
                }

                field("Number2"; rec."Number2")
                {
                    ApplicationArea = All;
                }

                field("Result"; rec."Result")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Description"; rec."Description")
                {
                    ApplicationArea = All;
                }

                field("CodeValue"; rec."CodeValue")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("DecimalValue"; rec."DecimalValue")
                {
                    ApplicationArea = All;
                }

                field("ConvertedInteger"; rec."ConvertedInteger")
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
            action(Calculate)
            {
                Caption = 'Calculate';
                ApplicationArea = All;
                trigger OnAction()
                var
                    RecRef: RecordRef;
                begin
                    rec.Result := rec."Number1" + rec."Number2"; // Penjumlahan Number1 dan Number2

                    // Konversi teks ke kode
                    rec."CodeValue" := rec."Description";

                    // Konversi Decimal ke Integer
                    rec."ConvertedInteger" := Round(rec."DecimalValue");

                    rec.Modify(true); // Simpan perubahan
                    Message('Calculation Complete!');
                end;
            }
        }
    }
}


// Penjelasan Page:

// Page ini menampilkan field yang sama seperti yang ada di table.
// Pada area actions, terdapat tombol Calculate untuk memproses assignment dan konversi:
// Penjumlahan dilakukan antara "Number1" dan "Number2" dan hasilnya disimpan di "Result".
// Field "Description" dikonversi ke tipe Code dan hasilnya disimpan di "CodeValue".
// Field "DecimalValue" dikonversi menjadi integer dan hasilnya disimpan di "ConvertedInteger".
// Tombol Calculate akan menjalankan proses assignment dan konversi, menampilkan pesan setelah proses selesai, dan memperbarui nilai di page.