namespace VSL.LINE;

using Microsoft.Foundation.NoSeries;
using PR.VSL;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Setup;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.PaymentTerms;
USING Microsoft.Inventory.Item;
using PR.RFQ;

table 60108 "Vendor Selection Line"
{


    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Selection Header"."No.";

        }

        field(2; "No."; Code[20])
        {
            TableRelation = Item where(Blocked = const(false), "Purchasing Blocked" = const(false));
        }

        field(3; "RFQ No"; Code[20])
        {
            TableRelation = Rfqline."PPB Document No.";
        }

        field(4; "Vendor No."; Code[20])
        {
            TableRelation = "Vendor Selection Header"."Vendor No.";
        }

        field(5; "Vendor Name"; Code[20])
        {
            TableRelation = Vendor.Name;
        }

        field(6; "PartNumber"; Code[20])
        {

        }

        field(7; "Item Description"; Code[20])
        {

        }



        field(10; "Unit Cost"; Decimal)
        {

        }

        field(11; "Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms";
        }

        field(12; "Estimate Delivery Date"; Code[20])
        {

        }

        field(13; "VAT"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
        }

        field(14; "WHT"; Code[20])
        {

        }

        field(15; "PBBKB"; Decimal)
        {

        }

        field(16; "Ongkos Angkut"; Decimal)
        {

        }

        field(17; "Jenis Angkutan"; Enum "Jenis Angkutan")
        {

        }

        field(18; "Mark to PO"; Boolean)
        {

        }

        field(19; "Purchased"; Decimal)
        {

        }

        field(20; "Line No."; Decimal)
        {

        }

        field(21; "No. Series"; Code[20])
        {

        }







    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    begin
        InitInsert();
    end;


    procedure InitInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then
            if "Document No." = '' then begin
                TestNoSeries();
                //NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", WorkDate(), "Document No.", "No. Series");
                NoSeries.AreRelated(GetNoSeriesCode(), xRec."No. Series");
            end;
        InitRecord();
    end;

    procedure InitRecord()
    var
        IsHandled, SkipInitialization : Boolean;
    begin
        GetPurchSetup();
        IsHandled := false;

        if SkipInitialization then
            exit;



    end;


    procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetPurchSetup();
        IsHandled := false;
        if not IsHandled then begin
            PurchSetup.TestField("RFQ Noseries");
        end;
    end;

    local procedure GetPurchSetup()
    begin
        PurchSetup.Get();
    end;

    procedure GetNoSeriesCode(): Code[20]
    var
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
    begin
        GetPurchSetup();
        IsHandled := false;
        if IsHandled then
            exit(NoSeriesCode);
        NoSeriesCode := PurchSetup."RFQ Noseries";
        //exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, true, "No. Series"));
        exit(NoSeries.GetNextNo(NoSeriesCode));
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
}