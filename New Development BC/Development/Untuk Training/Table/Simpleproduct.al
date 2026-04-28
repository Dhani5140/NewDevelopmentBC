table 52222 SimpleProduct
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product ID"; Code[10])
        {
            Caption = 'Product ID';
        }

        field(2; "Product Name"; Text[50])
        {
            Caption = 'Product Name';
        }

        field(3; "Price"; Decimal)
        {
            Caption = 'Price';
        }

        field(4; "Quantity Available"; Integer)
        {
            Caption = 'Quantity Available';
        }

        field(5; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
    }

    keys
    {
        key(PK; "Product ID")
        {
            Clustered = true;
        }
    }
}





// Penjelasan:
// •	Code[10]: Fundamental data type untuk kode produk.
// •	Text[50]: Menyimpan nama produk.
// •	Decimal: Menyimpan harga dengan presisi.
// •	Integer: Menyimpan jumlah produk tersedia.
// •	Boolean: Menandai apakah produk aktif atau tidak.

