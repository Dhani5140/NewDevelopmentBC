namespace PR.PB;

using Microsoft.Finance.Dimension;
using Microsoft.Inventory.Ledger;
using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Journal;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Document;
using PR.PPB;
using Microsoft.Inventory.Posting;


table 60100 PBHeader
{
    DataCaptionFields = "No.";

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
        field(5; "Spare Part"; Code[20])
        {
            Caption = 'Jenis Alat';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                          Blocked = const(false));
        }
        field(6; "Keperluan"; Text[100])
        {

        }
        field(7; Status; Enum "Purchase Document Status")
        {

        }
        field(8; Type; Enum PBType)
        {

        }
        field(9; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(10; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(11; "Posting No. Series"; Code[20])
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

        field(12; Requester; Text[200])
        {
            Caption = 'Requester';
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


    local procedure GetPurchSetup()
    begin
        PurchSetup.Get();
    end;

    procedure InitInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if not IsHandled then
            if "No." = '' then begin
                TestNoSeries();
                // NoSeriesMgt.InitSeries(GetNoSeriesCode(), xRec."No. Series", WorkDate(), "No.", "No. Series");
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
        if ("No. Series" <> '') and (PurchSetup."PB Noseries" = PostingNoSeries) then
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
            PurchSetup.TestField("PB Noseries");
        end;
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
        NoSeriesCode := PurchSetup."PB Noseries";
        //exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, true, "No. Series"));
    end;

    // procedure GetNoSeriesCode(): Code[20]
    // var
    //     NoSeriesCode: Code[20];
    //     //RelatedNoSeriesCode: Code[20];
    //     IsHandled: Boolean;
    // begin
    //     GetPurchSetup();
    //     IsHandled := false;
    //     if IsHandled then
    //         exit(NoSeriesCode);

    //     NoSeriesCode := PurchSetup."PB Noseries";

    //     exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode, true, "No. Series"));

    //     if NoSeries.LookupRelatedNoSeries(NoSeriesCode, "No. Series") then
    //         exit("No. Series")
    //     else
    //         Error('No related No. Series found for %1.', NoSeriesCode);
    // end;


    procedure DeliverItem()
    var
        ItemJournal: Record "Item Journal Line";
        PBLine: Record PBLine;
        PBHeader: Record PBHeader;
    begin
        PBHeader.SetRange("No.", Rec."No.");
        if PBHeader.FindSet() then begin
            PBLine.SetRange("Document No.", PBHeader."No.");
            PBLine.SetFilter(Quantity, '>%1', 0);
            if PBLine.FindSet() then begin
                repeat
                    if PBLine."Quantity Delivered" = 0 then begin
                        ItemJournal."Posting Date" := WorkDate();
                        ItemJournal."Journal Template Name" := 'ITEM';
                        ItemJournal."Journal Batch Name" := 'DEFAULT';
                        ItemJournal."Document No." := PBLine."Document No.";
                        ItemJournal."Line No." := PBLine."Line No.";
                        ItemJournal.Insert();
                        ItemJournal."Item No." := PBLine."No.";
                        ItemJournal.Modify();
                        ItemJournal.Validate("Item No.");
                        ItemJournal.Modify();
                        ItemJournal."Shortcut Dimension 1 Code" := PBLine.Departement;
                        ItemJournal."Gen. Prod. Posting Group" := PBLine.genprodposting;
                        ItemJournal."Entry Type" := ItemJournal."Entry Type"::"Negative Adjmt.";
                        ItemJournal."Location Code" := PBLine."Location Code";
                        ItemJournal.Quantity := PBLine."Qty to Deliver";
                        ItemJournal."Unit of Measure Code" := PBLine."Unit of Measure Code";
                        ItemJournal.Modify();
                        ItemJournal.Validate(Quantity);
                        ItemJournal.Modify();
                        ItemJournal.ValidateShortcutDimCode(5, PBLine."Unit Code");
                        ItemJournal.Modify();

                        PBLine."Quantity Delivered" := PBLine."Qty to Deliver";
                        PBLine.Modify();
                        PBLine."Qty to Deliver" := 0;
                        PBLine.Modify();
                    end;
                until PBLine.Next = 0;
            end;
            ItemJournal.SetRange("Document No.", PBHeader."No.");
            if ItemJournal.FindSet() then begin
                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJournal);
            end;
        end;
    end;

    procedure TransferPPB()
    var
        PPBHeader: Record PPBHeader;
        PBHeader: Record PBHeader;
        DocNo: Code[20];
    begin
        PBHeader.SetRange("No.", Rec."No.");
        if PBHeader.FindSet() then begin
            PPBHeader.InitInsert();
            PPBHeader."Request Date" := WorkDate();
            PPBHeader."No. PB" := PBHeader."No.";
            PPBHeader."PB Date" := PBHeader."Request Date";
            PPBHeader.Requester := PBHeader.Requester;
            PPBHeader.Keperluan := PBHeader.Keperluan;
            PPBHeader.Departement := PBHeader.Departement;
            PPBHeader."Unit Code" := PBHeader."Unit Code";
            PPBHeader.Insert();
            //PPBHeader.Validate("No.");
            DocNo := PPBHeader."No.";
            TransferPPBLine(Rec."No.", DocNo);
            Message('Transfer To PPB Success. PPB No: %1', DocNo);
        end;
    end;

    local procedure TransferPPBLine(DocNo: Code[20]; PPBNo: Code[20])
    var
        PBLine: Record PBLine;
        PPBLine: Record PPBLine;
    begin
        PBLine.SetRange("Document No.", DocNo);
        PBLine.SetAscending("Document No.", true);
        if PBLine.FindSet() then begin
            repeat
                PPBLine."Document No." := PPBNo;
                PPBLine."Line No." += 10000;
                PPBLine."PB Document No." := PBLine."Document No.";
                PPBLine."PB Line No." := PBLine."Line No.";
                PPBLine."No." := PBLine."No.";
                PPBLine."Location Code" := PBLine."Location Code";
                PPBLine."Item Description" := PBLine."Item Description";
                PPBLine."Part Number" := PBLine."Part Number";
                PPBLine."Unit of Measure Code" := PBLine."Unit of Measure Code";
                PPBLine."Qty Requested" := PBLine.Quantity;
                PPBLine."Qty. to Order" := PBLine.Quantity;
                PPBLine.Insert();
            until PBLine.Next = 0;
        end
    end;


    var
        PurchSetup: Record "Purchases & Payables Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
}