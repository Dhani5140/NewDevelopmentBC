report 53343 "PO with Invoice Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = POInvoiceLink;
    Caption = 'Report: PO with Invoices';

    dataset
    {
        // Data item utama: Purchase Header (PO)
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            column(No_; "No.")
            {

            }
            column(Vendor_Order_No_; "Vendor Order No.")
            { }

            // Data item kedua: Purch. Inv. Header (Invoice)
            dataitem("Purchase Header"; "Purchase Header")
            {
                DataItemLinkReference = "Purch. Inv. Header";
                DataItemLink = "No." = field("Order No."); // Menghubungkan Purchase Header dengan Invoice berdasarkan Order No.

                column(No_1; "No.")
                {

                }

            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Filter Options")
                {
                }
            }
        }
    }

    rendering
    {
        layout(POInvoiceLink)
        {
            Type = RDLC;
            LayoutFile = 'POInvoiceLink.rdl';
        }
    }


    var

}
