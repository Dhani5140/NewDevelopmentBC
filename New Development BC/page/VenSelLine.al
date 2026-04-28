namespace VSL.LINE;
using Microsoft.Purchases.Vendor;
using Microsoft.Inventory.Item;
using PR.RFQ;
using PR.VSL;

page 60118 EXE
{
    PageType = ListPart;
    Caption = 'Vendor Selection Line';
    ApplicationArea = All;
    UsageCategory = Administration;
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
                    Editable = false;
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
                    Editable = false;
                    Caption = 'Item Description';
                }
                field("Part Number"; Rec."Part Number")
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Editable = false;
                    Caption = 'Part Number';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Editable = false;
                    Caption = 'Quantity';
                }
                field("PPB Document No."; Rec."PPB Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(UoM; Rec.UoM)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    Editable = false;
                    Caption = 'UoM';
                }

                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = ALL;
                    TableRelation = RFQHEADER.VendorNo;
                    Editable = false;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    TableRelation = RFQHEADER.vendorname;
                    Editable = false;
                }

                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = all;
                    Editable = true;
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