namespace PR;

using PR.PB;
report 60100 "PB REPORT"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = pbreport;

    dataset
    {
        dataitem(PBHeader; PBHeader)
        {
            RequestFilterFields = "No.";
            column(Unit_Code; "Unit Code")
            {

            }
            column(Spare_Part; "Spare Part")
            {

            }
            column(Departement; Departement)
            {

            }
            column(Keperluan; Keperluan)
            {

            }
            column(No_; "No.")
            {

            }
            column(Request_Date; "Request Date")
            {

            }

            dataitem(PBLine; PBLine)
            {
                DataItemLinkReference = PBHeader;
                DataItemLink = "Document No." = field("No.");

                column(Document_No_; "Document No.")
                {

                }
                column(No_1; "No.")
                {

                }

                column(Part_Number; "Part Number")
                {

                }
                column(Item_Description; "Item Description")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Keperluan1; Keperluan)
                {

                }

            }
        }
    }





    rendering
    {
        layout(pbreport)
        {
            Type = RDLC;
            LayoutFile = 'pbreport.rdl';
        }
    }

    var
        myInt: Integer;
}