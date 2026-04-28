namespace PR.RFQ;
using Microsoft.Foundation.NoSeries;
using PR.PPB;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Foundation.PaymentTerms;

table 60105 RFQHEADER
{


    fields
    {
        field(1; "No."; code[20])
        {
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    GetPurchSetup();
                    NoSeries.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; Peuntukan; text[100])
        {
            Caption = 'Peruntukan';

        }
        field(4; VendorNo; Code[20])
        {
            Caption = 'Vendor No';
            TableRelation = Vendor;

        }
        field(5; vendorname; text[100])
        {
            Caption = 'Vendor Name';
            TableRelation = Vendor.Name;

        }

        field(6; PYT; CODE[20])
        {
            Caption = 'Payment Terms';
            TableRelation = "Payment Terms";
        }
        field(7; EstimateDelivery; Date)
        {
            Caption = 'Estimate Delivery Date';

        }
        field(8; Status; Enum "Purchase Document Status")
        {

        }
        field(9; "No.PPB"; Code[20])
        {
            Caption = 'No. PPB';
            TableRelation = PPBHeader;
        }

    }

    keys
    {
        key(Key1; "No.", "No.PPB")
        {
            Clustered = true;
        }

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
            if "No." = '' then begin
                TestNoSeries();
                //NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", WorkDate(), "No.", "No. Series");
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