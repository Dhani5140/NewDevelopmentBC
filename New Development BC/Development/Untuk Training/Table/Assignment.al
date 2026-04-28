table 52223 AssignmentExample
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Number1"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Number2"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Result"; Integer)
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Description"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "CodeValue"; Code[10])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "DecimalValue"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(7; "ConvertedInteger"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}


// Penjelasan Table:

// Field "Number1" dan "Number2" adalah nilai integer yang akan digunakan dalam operasi penjumlahan.
// Field "Result" menyimpan hasil penjumlahan dari "Number1" dan "Number2".
// Field "Description" adalah teks yang akan dikonversi ke tipe Code.
// Field "CodeValue" akan menyimpan nilai yang dikonversi dari Description.
// Field "DecimalValue" adalah angka desimal yang nantinya akan dikonversi ke integer.
// Field "ConvertedInteger" menyimpan hasil konversi dari DecimalValue ke integer.