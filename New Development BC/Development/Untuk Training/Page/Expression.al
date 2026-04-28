page 50100 ExpressionExampleCard
{
    PageType = Card;
    SourceTable = ExpressionExample;
    ApplicationArea = All;
    Caption = 'Expression Example';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ID; Rec.ID) { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field(NumericExpression; Rec.NumericExpression) { ApplicationArea = All; }
                field(RelationalExpression; Rec.RelationalExpression) { ApplicationArea = All; }
                field(BooleanExpression; Rec.BooleanExpression) { ApplicationArea = All; }
                field(ConcatenatedString; Rec.ConcatenatedString) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CalculateExpressions)
            {
                ApplicationArea = All;
                Caption = 'Calculate Expressions';

                trigger OnAction()
                var
                    Num1, Num2 : Integer;
                begin
                    Num1 := 5;
                    Num2 := 3;

                    // Arithmetic Expression Example: (5 + 3) * 2
                    Rec.NumericExpression := (Num1 + Num2) * 2;

                    // Relational Expression Example: 5 > 3
                    Rec.RelationalExpression := Num1 > Num2;

                    // Boolean Expression Example: TRUE AND FALSE
                    Rec.BooleanExpression := true AND false;

                    // String Concatenation Example: 'Hello' + ' World'
                    Rec.ConcatenatedString := 'Hello' + ' World';

                    rec.Modify(true);
                    Commit();
                end;
            }
        }
    }
}


// Penjelasan Kode:
// Table ExpressionExample: Tabel ini menyimpan contoh ekspresi dengan berbagai tipe data,
// termasuk Decimal untuk hasil ekspresi numerik, Boolean untuk ekspresi relasional dan boolean, 
//serta Text untuk hasil penggabungan string.

// Page ExpressionExampleCard: Halaman ini adalah tampilan Card yang menampilkan data dari tabel ExpressionExample 
//dengan tombol Calculate Expressions untuk menjalankan berbagai ekspresi.

// Action CalculateExpressions: Aksi ini menjalankan berbagai ekspresi, 
//termasuk ekspresi aritmatika (Num1 + Num2) * 2, ekspresi relasional Num1 > Num2,
// ekspresi boolean true AND false, dan penggabungan string 'Hello' + ' World'.