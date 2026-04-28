page 52111 "Faktur Pajak Lookup"
{
    PageType = List;
    SourceTable = "Table View Generate Line2"; // Ganti dengan nama tabel faktur pajak
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Faktur Pajak No"; Rec."Faktur Pajak No")
                {
                    ApplicationArea = all;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Status"; rec.Status)
                {
                    ApplicationArea = All;
                }
                // field("Tanggal"; rec.) // Atau field Tanggal yang benar
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select")
            {
                Caption = 'Select';
                trigger OnAction()
                begin
                    CurrPage.Close(); // Tutup page setelah memilih
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Status, rec.Status::FREE); // Hanya tampilkan faktur pajak yang berstatus Open
    end;
}

