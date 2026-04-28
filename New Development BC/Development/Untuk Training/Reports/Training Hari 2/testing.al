report 53322 "PO Invoice Training Report"
{
    Caption = 'PO Invoice Training Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = POLine;


    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));


            column(No_; "No.")
            {

            }

            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }

            column(Vendor_Invoice_No_; "Vendor Invoice No.")
            {

            }

            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_1; "No.")
                { }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Price__LCY_; "Unit Price (LCY)")
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
                group(Group)
                {
                }
            }
        }
    }
    rendering
    {
        layout(POLine)
        {
            Type = RDLC;
            LayoutFile = 'POHeader dan PO Line.rdl';
        }
    }


    var

}