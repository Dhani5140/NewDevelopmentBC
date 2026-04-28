query 53333 Customer
{
    QueryType = Normal;

    elements
    // Data item utama: Customer
    {
    dataitem(Customer; Customer)
    {

        column(No_;"No.")
        {
        }
        column(Name;Name)
        {
        }
        column("City"; City)
        {
        }

        dataitem(Cust__Ledger_Entry;"Cust. Ledger Entry")
        {
            DataItemLink = "Customer No." = customer."No.";
            SqlJoinType = InnerJoin;
            //DataItemTableFilter = "Document Type" = filter('Order');

            column(Document_No_;"Document No.")
            {

            }
            // column(Document_Type;"Document Type")
            // {
            //    //ColumnFilter = Document_Type = filter('Order'); 
            // }

            column(Amount;Amount)
            {

            }
        }
    }
    }
}

        // Data item kedua dengan INNER JOIN ke Customer berdasarkan Customer No.
       
