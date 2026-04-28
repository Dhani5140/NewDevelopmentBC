namespace PR.RFQ;
using Microsoft.Inventory.Item;
using PR.PPB;
using Microsoft.Purchases.Vendor;
page 60112 RFQLine
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'RFQ Lines';
    SourceTable = Rfqline;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'No';


                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'Item No';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        ItemUpdate();
                    end;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Caption = 'Item Description';
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Caption = 'Part Number';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'Quantity';
                }
                field("PPB Document No."; Rec."PPB Document No.")
                {
                    ApplicationArea = all;
                }
                field(UoM; Rec.UoM)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Caption = 'UoM';
                }

                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = ALL;

                    TableRelation = RFQHEADER.VendorNo;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    TableRelation = RFQHEADER.vendorname;
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

                ApplicationArea = SUITE;
                Ellipsis = true;
                Caption = 'Get Purchase Request Line';

                trigger OnAction()

                begin
                    Getppb();
                end;
            }
        }
    }

    var
        rfqhead: Record RFQHEADER;

    trigger OnAfterGetRecord()
    begin
        DocumentPPB();
        vendorlines();
    end;


    trigger OnAfterGetCurrRecord()
    begin
        vendorlines();
        DocumentPPB();
    end;

    var
        myInt: Integer;




    local procedure ItemUpdate()
    var
        item: Record Item;

    begin
        item.SetRange("No.", rec."No.");
        if item.FindSet() then begin
            Rec."Item Description" := item.Description;
            rec.UoM := item."Base Unit of Measure";
            rec."Part Number" := item.part_number;
            rec.Modify();

        end;
    end;

    local procedure vendor()
    var
        vendor: Record Vendor;
        rfqhe: Record RFQHEADER;

    begin
        rfqhe.SetRange("No.", rec."No.");
        rfqhe.SetRange(VendorNo, rec."Vendor No");
        if rfqhe.FindSet() then begin
            rec."Vendor Name" := rfqhe.vendorname;
            rec.Modify();

        end;

    end;

    procedure Getppb()
    begin

        CODEUNIT.Run(CODEUNIT::GetPpbLine, Rec);
    end;

    local procedure DocumentPPB()
    var
        rfqhead: Record RFQHEADER;

    begin
        rfqhead.SetRange("No.", rec."No.");
        if rfqhead.FindSet() then begin
            Rec."No." := rfqhead."No.";
            rec."PPB Document No." := rfqhead."No.PPB";

        end;
    end;


    local procedure vendorlines()
    var
        rfqheader: Record RFQHEADER;

    begin
        rfqheader.SetRange("No.", rec."No.");
        if rfqheader.FindSet() then begin
            Rec."Vendor No" := rfqheader.VendorNo;
            rec."Vendor Name" := rfqheader.vendorname;

        end;
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeOnQueryClosePage(CloseAction: Action; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetPurchHeader(var rfqhead: Record RFQHEADER; var IsHandled: Boolean; var PurchHeader: Record RFQHEADER)
    begin
    end;


}