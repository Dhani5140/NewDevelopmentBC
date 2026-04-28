page 52237 "Expressions Card point 2"
{
    PageType = Card; // Menentukan tipe halaman sebagai Card
    ApplicationArea = All; // Menentukan area aplikasi di mana halaman ini tersedia
    UsageCategory = Documents; // Mengkategorikan halaman dalam bagian Documents
    Caption = 'Expressions Card point 2'; // Memberikan judul untuk halaman ini

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Input'; // Grup untuk input dengan nama Input
                field(Value1; Value1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a value for Value1.'; // Menampilkan informasi untuk field Value1
                    Caption = 'Value1'; // Memberikan label Value1 pada field
                }
                field(Value2; Value2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter a value for Value2.'; // Menampilkan informasi untuk field Value2
                    Caption = 'Value2'; // Memberikan label Value2 pada field
                }
            }
            group(Output)
            {
                Caption = 'Output'; // Grup untuk output dengan nama Output
                field(Result; Result)
                {
                    ApplicationArea = All;
                    ToolTip = 'The result of the operation.'; // Menampilkan informasi untuk field Result
                    Caption = 'Result'; // Memberikan label Result pada field
                    Editable = false; // Mengatur agar field Result tidak dapat diedit
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Execute)
            {
                ApplicationArea = All;
                Caption = 'Execute'; // Memberikan label Execute pada tombol
                ToolTip = 'Click to calculate the result.'; // Menampilkan informasi untuk tombol Execute
                Image = ExecuteBatch; // Menentukan ikon untuk tombol Execute

                trigger OnAction()
                begin
                    // Logika untuk mengevaluasi apakah Value1 lebih besar dari Value2
                    Result := Value1 > Value2; // Jika benar, Result akan bernilai true; jika tidak, false
                end;
            }
        }
    }

    var
        Value1: Integer; // Variabel untuk menyimpan nilai input pertama
        Value2: Integer; // Variabel untuk menyimpan nilai input kedua
        Result: Boolean; // Variabel untuk menyimpan hasil perbandingan antara Value1 dan Value2
}
