page 81111 "Generate Pajak Page"
{
    Caption = 'Generate Pajak Page';
    PageType = List;
    SourceTable = "Generate Pajak Table2";
    ApplicationArea = all;
    UsageCategory = Lists;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Faktur Pajak ID"; Rec."Faktur Pajak ID")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                field("Branch code1"; Rec."Branch code1")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                field("Transaction Code1"; Rec."Transaction Code1")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                field("Status Code Pajak"; Rec."Status Code Pajak")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                    Caption = 'Status Code';
                }

                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = all;
                    Editable = false; // Tidak bisa diubah
                    Caption = 'Status';
                }

                field(Year; Rec.Year)
                {
                    ApplicationArea = all;
                    Editable = IsEditable;

                }

                field("From No"; Rec."From No")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                field("To No"; Rec."To No")
                {
                    ApplicationArea = all;
                    Editable = IsEditable;
                }

                // field("Number Prefix"; Rec."Number Prefix")
                // {
                //     ApplicationArea = all;
                //     Editable = IsEditable;
                // }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Generate)
            {
                ApplicationArea = all;
                Caption = 'Generate';
                Image = Action;

                trigger OnAction()
                var
                    vw: Record "Table View Generate Header";
                    gCUPajakFunct: Codeunit "Generate Pajak";
                begin
                    // Validasi: Pastikan status sudah "Active"
                    if Rec."Status Code" <> Rec."Status Code"::Active then
                        Error('Status must be Active to generate.');

                    // Ubah status menjadi "Generated"
                    Rec."Status Code" := Rec."Status Code"::Generated;

                    // Simpan perubahan ke database
                    if not Rec.Modify() then
                        Error('Failed to update record to Generated.');

                    // Panggil fungsi generate di codeunit
                    gCUPajakFunct.Genertad(Rec);

                    // Perbarui tampilan page
                    CurrPage.Update();
                    Message('%1 records Invoice Code Created', Rec."Faktur Pajak ID");
                    // Tampilkan data di page view
                    vw.SetRange("Faktur Pajak ID", Rec."Faktur Pajak ID");
                    Page.Run(Page::"Page view Generate", vw);
                end;
            }

            action(Active)
            {
                ApplicationArea = all;
                Caption = 'Active';
                Image = Apply;

                trigger OnAction()
                begin
                    if (rec.Year = '') then
                        Error('Tahun Harus diisi terlebih dahulu');

                    if (Rec."From No" = 0) then
                        Error('From No harus di isi');

                    if (Rec."To No" = 0) then
                        Error('To No harus di isi');

                    // Cek apakah status saat ini "Open". Jika tidak, tampilkan error.
                    if Rec."Status Code" <> Rec."Status Code"::Open then
                        Error('Status must be Open to activate.');

                    // Ubah status menjadi "Active"
                    Rec."Status Code" := Rec."Status Code"::Active;

                    // Simpan perubahan ke database
                    if not Rec.Modify() then
                        Error('Failed to update record.');


                    // Perbarui tampilan page
                    CurrPage.Update();

                    // Tampilkan pesan konfirmasi
                    Message('Document has been activated.');
                end;
            }
            // action(Suspend)
            // {
            //     ApplicationArea = all;
            //     Caption = 'Suspend';
            //     Image = Close;
            //     trigger OnAction()
            //     begin
            //         if Rec."Status Code" in [rec."Status Code"::Open] = false then Error('Status must be Open');
            //         rec.Validate("Status Code", rec."Status Code"::Suspend);
            //         CurrPage.Update();
            //         Message(rec."Faktur Pajak ID", 'Suspend');
            //     end;
            // }
            action(Reopen)
            {
                ApplicationArea = all;
                Caption = 'Re-Open';
                Image = ReOpen;
                trigger OnAction()
                begin
                    // Validasi: Pastikan status sudah "Active"
                    if Rec."Status Code" <> Rec."Status Code"::Active then
                        Error('Status must be active to re-open.');

                    // Ubah status menjadi "Active"
                    Rec."Status Code" := Rec."Status Code"::Open;

                    // Simpan perubahan ke database
                    if not Rec.Modify() then
                        Error('Failed to update record.');

                    // Perbarui tampilan page
                    CurrPage.Update();

                    // Tampilkan pesan konfirmasi
                    Message('Document has been Open.');
                end;

            }



        }
        area(Navigation)
        {
            action(view)
            {
                ApplicationArea = all;
                Caption = 'View';
                Image = View;
                trigger OnAction()
                var
                    vw: Record "Table View Generate Header";
                begin
                    vw.SetRange("Faktur Pajak ID", rec."Faktur Pajak ID");
                    page.Run(page::"Page view Generate", vw);
                end;
            }
        }

    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Rec."Status Code" := Rec."Status Code"::Open; // Set status menjadi Open
        // CurrPage.Editable := true; // Paksa masuk mode edit
    end;

    trigger OnOpenPage()
    begin
        SetEditable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEditable();
    end;

    var
        IsEditable: Boolean;


    procedure SetEditable()
    begin
        // Editable hanya jika Status Code = Open
        IsEditable := (Rec."Status Code" = Rec."Status Code"::Open);
    end;
}
