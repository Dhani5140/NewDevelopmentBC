
report 60101 "RFQ Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = Rfq;

    dataset
    {
        dataitem(RFQHEADER; RFQHEADER)
        {
            RequestFilterFields = "No.";

            column(Cname; companyinfo.Name)
            {

            }

            column(Cadd; companyinfo.Address)
            {

            }
            column(Cadd1; companyinfo."Address 2")
            {

            }
            column(cCity; companyinfo.City)
            {

            }
            column(Ccountry; companyinfo.County)
            {

            }

            column(vendorname; vendorname)
            {

            }

            column(No_; "No.")
            {

            }

            column(EstimateDelivery; EstimateDelivery)
            {

            }



            dataitem(Rfqline; Rfqline)
            {
                DataItemLinkReference = RFQHEADER;
                DataItemLink = "No." = field("No.");

                column(Item_Description; "Item Description")
                {

                }

                column(Part_Number; "Part Number")
                {

                }

                column(Quantity; Quantity)
                {

                }

                column(UoM; UoM)
                {

                }

            }
        }
    }





    rendering
    {
        layout(Rfq)
        {
            Type = RDLC;
            LayoutFile = 'Rfq.rdl';
        }
    }
    trigger OnPreReport()
    begin
        companyinfo.Get;
        companyinfo.CalcFields(Picture);
    end;

    var
        companyinfo: Record "Company Information";
}