namespace VSL.LINE;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.NoSeries;
using PR.RFQ;
using Microsoft.Purchases.Setup;
using PR.VSL;

page 60121 cockpit
{
    PageType = List;
    Caption = 'Vendor Selection Cockpit ';
    ApplicationArea = all;
    UsageCategory = Administration;
    InsertAllowed = true;
    ModifyAllowed = true;
    SourceTable = "Vendor Selection Header";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {



                field("Nomor PPB"; Rec."Nomor PPB")
                {

                }

                field("Item No"; Rec."Item No")
                {

                }

                field("Item Description"; Rec."Item Description")
                {

                }

                field("Part Number"; Rec."Part Number")
                {

                }

                field(Quantity; Rec.Quantity)
                {

                }




            }




        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    local procedure rfq()
    var
        rfqli: Record Rfqline;

    begin
        rfqli.SetRange("No.", rec."Nomor PPB");
        if rfqli.FindSet() then begin
            rec."Item No" := rfqli."No.";
            Rec."Item Description" := rfqli."Item Description";
            Rec.Quantity := rfqli.Quantity;
            rec."Line No." := rfqli."Line No.";
            rec."Part Number" := rfqli."Part Number";


        end;

    end;



}