page 52224 SimpleProductPage
{
    PageType = List;
    SourceTable = SimpleProduct;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product ID"; Rec."Product ID")
                {
                    ApplicationArea = All;
                }

                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                }

                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }

                field("Quantity Available"; Rec."Quantity Available")
                {
                    ApplicationArea = All;
                }

                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AddNewProduct)
            {
                Caption = 'Add New Product';
                ApplicationArea = All;
                Image = View;

                trigger OnAction()
                begin
                    CreateProduct();
                end;
            }
        }
    }

    procedure CreateProduct()
    var
        product: Record SimpleProduct;
    begin
        product.Init();
        product."Product ID" := 'PROD001';
        product."Product Name" := 'Sample Product';
        product.Price := 100.00;
        product."Quantity Available" := 50;
        product."Is Active" := true;
        product.Insert();
        Message('Product has been added successfully.');
    end;
}


// Penjelasan:
// 1.	PageType = List: Halaman ini adalah daftar produk.
// 2.	Repeater: Menampilkan data dari tabel secara berulang untuk setiap produk.
// 3.	Actions: Menambahkan tombol untuk membuat produk baru.
// 4.	Procedure CreateProduct: Contoh penggunaan complex data type berupa Record untuk menyimpan produk baru ke tabel.
// ________________________________________
// Cara Kerja:
// •	Saat halaman SimpleProductPage dibuka, pengguna dapat melihat daftar produk.
// •	Tombol "Add New Product" memungkinkan pengguna menambahkan produk baru secara otomatis dengan nilai contoh.
// •	Message akan memberi notifikasi setelah produk ditambahkan.
// Dengan kode ini, Anda memiliki contoh sederhana untuk penggunaan fundamental dan complex data types dalam table dan page di Dynamics 365 Business Central.
