report 53342 Example_DataItems_Join
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = Customertest;
    Caption = 'customertest';


    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            column(CustomerNo; "No.")
            {
            }
            column(CustomerName; Name)
            {
            }
            dataitem(CustomerLedgers; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Customer No.");
                RequestFilterFields = "Document No.";
                column(CustomerLedgersCustomerNo; "Customer No.")
                {
                }
                column(CustomerLedgersAmountLCY; "Amount (LCY)")
                {
                }
            }
            trigger OnPreDataItem()
            begin
                if HideBlockedCustomers then
                    Customer.SetRange(Blocked, Blocked::" ");
                Customer.SetRange("Last Date Modified", startingdate, endingdate);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(HideBlockedCustomers; HideBlockedCustomers)
                    {
                        ApplicationArea = All;
                        Caption = 'Hide Blocked Customers?';

                    }
                    field(startingdate; startingdate)
                    {
                        ApplicationArea = all;
                    }
                    field(endingdate; endingdate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    rendering
    {
        layout(Customertest)
        {
            Type = RDLC;
            LayoutFile = 'customertest.rdl';
        }
    }
    var
        HideBlockedCustomers: Boolean;
        startingdate: Date;
        endingdate: Date;
}