namespace PR.PPB;

using Microsoft.Finance.Dimension;
using Microsoft.Foundation.NoSeries;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Document;
table 60103 PPBHeader
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
        field(2; "Request Date"; Date)
        {

        }
        field(3; "Departement"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(4; "Unit Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false));
        }
        field(5; "Keperluan"; Text[100])
        {

        }
        field(6; Status; Enum "Purchase Document Status")
        {

        }

        field(7; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(8; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }

        field(9; Requester; Text[200])
        {
            Caption = 'Requester';
        }
        field(10; "No. PB"; code[20])
        {
            Editable = false;
        }

        field(11; "PB Date"; Date)
        {
            Editable = false;
        }
        field(12; "Rencana Penggunaan"; Text[100])
        {

        }
        field(13; "Alasan Investasi"; Text[100])
        {

        }
        field(14; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                GetPurchSetup();
                TestNoSeries();
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    GetPurchSetup();
                    TestNoSeries();
                end;
                TestField("Posting No.", '');
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
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
        if not IsHandled then
            InitPostingNoSeries();

        "Request Date" := WorkDate();
    end;

    local procedure InitPostingNoSeries()
    var
        PostingNoSeries: Code[20];
    begin
        if ("No. Series" <> '') and (PurchSetup."PPB Noseries" = PostingNoSeries) then
            "Posting No. Series" := "No. Series"
        //else
        //NoSeriesMgt.SetDefaultSeries("Posting No. Series", PostingNoSeries);
    end;

    procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        GetPurchSetup();
        IsHandled := false;
        if not IsHandled then begin
            PurchSetup.TestField("PPB Noseries");
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
        NoSeriesCode := PurchSetup."PPB Noseries";
        //exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, true, "No. Series"));
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";

}