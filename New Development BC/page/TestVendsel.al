namespace PR.VSL;
USING VSL.LINE;
using PR.RFQ;
using Microsoft.Purchases.Vendor;
page 60117 "tVendor Selection Header"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'test vendor selection';
    SourceTable = "Vendor Selection Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field("Tanggal IN"; Rec."Tanggal IN")
                {
                    ApplicationArea = suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                }

                field("Nomor PPB"; Rec."Nomor PPB")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'No. Purchase Request';
                }

                field(Peruntukan; Rec.Peruntukan)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'Peruntukan';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ShowMandatory = true;
                }

            }





        }
    }

    actions
    {
        area(Processing)
        {

        }
    }


}