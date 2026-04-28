namespace PR.VSL;

using Microsoft.Foundation.NoSeries;
using PR.VSL;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Setup;
using PR.PPB;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;
using PR.RFQ;
using Microsoft.Foundation.PaymentTerms;
table 60107 "Vendor Selection Header"
{
    DataClassification = ToBeClassified;

    fields
    {


        field(1; "No."; Code[20])
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

        }

        field(3; "Tanggal IN"; Date)
        {

        }

        field(4; "Nomor PPB"; Code[20])
        {
            TableRelation = PPBHeader."No.";
        }

        field(5; "Peruntukan"; Text[200])
        {

        }

        field(6; "Status"; Enum "Purchase Document Status")
        {

        }

        field(7; "Item No"; Code[20])
        {
            TableRelation = Item where(Blocked = const(false), "Purchasing Blocked" = const(false));

        }

        field(8; "Item Description"; text[100])
        {

        }

        field(9; "Part Number"; Text[100])
        {

        }

        field(10; Quantity; Decimal)
        {

        }

        field(11; "Line No."; Integer)
        {

        }
        field(12; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
        }

        field(13; "Vendor Name"; Code[20])
        {
            TableRelation = Vendor.Name;
        }
    }

    keys
    {
        key(Key1; "No.", "Nomor PPB")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


    var
        PurchSetup: Record "Purchases & Payables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";


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
            PurchSetup.TestField(vsl);
        end;
    end;

    local procedure GetPurchSetup()
    begin
        PurchSetup.get();
    end;

    local procedure GetNoseriesCode(): Code[20]
    var
        NoseriesCode: code[20];
        isHandled: Boolean;

    begin
        GetPurchSetup();
        isHandled := false;
        if isHandled then
            exit(NoseriesCode);
        NoseriesCode := PurchSetup.vsl;
        //exit(NoSeriesMgt.GetNoSeriesWithCheck(NoseriesCode, true, "No. Series"))
        exit(NoSeries.GetNextNo(NoSeriesCode));

    end;



    procedure TransferPQ()
    var
        Purchhead: Record "Purchase Header";
        Vendorsel: Record "Vendor Selection Header";
        DocNo: Code[20];
    begin
        Purchhead.SetFilter("Document Type", 'Order');
        Purchhead.SetRange("No.", Rec."No.");
        if Purchhead.FindSet() then begin
            Purchhead.InitInsert();
            Purchhead."Order Date" := WorkDate();
            Purchhead."Buy-from Vendor No." := Vendorsel."Vendor No.";
            Purchhead."Buy-from Vendor Name" := Vendorsel."Vendor Name";
            Purchhead.Insert();
            DocNo := Purchhead."No.";
            TransferPQLine(Rec."No.", DocNo);
            Message('Transfer To PQ Success.  No: %1', DocNo);
        end;
    end;

    local procedure TransferPQLine(DocNo: Code[20]; PPBNo: Code[20])
    var
        Purchline: Record "Purchase Line";
        RfqLine: Record Rfqline;
    begin
        Purchline.SetRange("Document No.", DocNo);
        Purchline.SetAscending("Document No.", true);
        if Purchline.FindSet() then begin
            repeat
                Purchline."Document No." := PPBNo;
                Purchline."Line No." += 10000;
                Purchline."No." := RfqLine."No.";
                Purchline.Description := RfqLine."Item Description";
                Purchline."Unit Cost" := RfqLine."Unit Amount";
                Purchline.Quantity := RfqLine.Quantity;
                Purchline.Insert();
            until Purchline.Next = 0;
        end
    end;





}