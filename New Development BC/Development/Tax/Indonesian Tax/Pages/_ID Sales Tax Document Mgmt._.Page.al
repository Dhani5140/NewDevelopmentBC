page 80139 "ID Sales Tax Document Mgmt."
{

    ApplicationArea = All;
    PageType = List;
    SourceTable = "Sales Tax Documents1";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Pick; Rec.Pick)
                {
                    ApplicationArea = All;
                }
                field("Pick Date"; Rec."Pick Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = all;
                }
                field("Faktur Date"; Rec."Faktur Date")
                {
                    ApplicationArea = all;
                }
                field("Faktur Pajak No"; Rec."Faktur Pajak No")
                {
                    ApplicationArea = all;
                }
                field("Tahun Pajak"; Rec."Tahun Pajak")
                {
                    ApplicationArea = all;
                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }

                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
                field("Tax No."; Rec."Tax No.")
                {
                    ApplicationArea = All;
                }
                field("Tax-Document Post"; Rec."Tax-Document Post")
                {
                    ApplicationArea = All;
                }
                field("NPWP No."; Rec."NPWP No.")
                {
                    ApplicationArea = all;
                }
                field("NPWP Name"; Rec."NPWP Name")
                {
                    ApplicationArea = All;
                }
                field("NPWP Address"; Rec."NPWP Address")
                {
                    ApplicationArea = All;
                }
                field("No. KTP"; Rec."No. KTP")
                {
                    ApplicationArea = All;
                }
                field(Amount; gdecDocAmount)
                {
                    ApplicationArea = All;
                }
                field("Amount Incl. VAT"; gdecDocAmountInclVAT)
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; VATAmount)
                {
                    ApplicationArea = All;
                }
                field("Amount Invoice"; Rec."Amount Invoice")
                {
                    ApplicationArea = All;
                }
                field("Amount Credit Memo"; Rec."Amount Credit Memo")
                {
                    ApplicationArea = All;
                }
                field("Amount Incl. VAT Invoice"; Rec."Amount Incl. VAT Invoice")
                {
                    ApplicationArea = All;
                }
                field("Amount Incl. VAT Credit Memo"; Rec."Amount Incl. VAT Credit Memo")
                {
                    ApplicationArea = All;
                }
                field("Amount Prepayment DPP"; Rec."Amount Prepayment DPP")
                {
                    ApplicationArea = all;
                }
                field("Amount Prepayment PPN"; Rec."Amount Prepayment PPN")
                {
                    ApplicationArea = all;
                }
                field("Amount Prepayment PPNBM"; Rec."Amount Prepayment PPNBM")
                {
                    ApplicationArea = all;
                }
                field("Additional Notes"; Rec."Additional Notes")
                {
                    ApplicationArea = all;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = all;
                }
                field("Additional Document No"; Rec."Additional Document No")
                {
                    ApplicationArea = all;
                }
                field(Exported; Rec.Exported)
                {
                    ApplicationArea = All;
                }
                field("Exported Date"; Rec."Exported Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Pick All")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    lrecSalesTaxDoc: Record "Sales Tax Documents1";
                begin
                    IF gboolActivateFilter THEN BEGIN
                        lrecSalesTaxDoc.SETRANGE("Tax-Document Post", gOptTaxDocPost);
                        lrecSalesTaxDoc.SETRANGE("Tax Type", gOptTaxType);
                        lrecSalesTaxDoc.SETRANGE("Document Type", gOptDocType);
                        IF gcodeCustNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Sell-to Customer No.", gcodeCustNo);
                        IF gcodeTaxNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Tax No.", gcodeTaxNo);
                        IF gcodeDocNo <> '' THEN lrecSalesTaxDoc.SETFILTER("No.", gcodeDocNo);
                    END;
                    lrecSalesTaxDoc.CopyFilters(Rec);
                    IF lrecSalesTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecSalesTaxDoc.Pick := TRUE;
                            lrecSalesTaxDoc.MODIFY();
                        UNTIL lrecSalesTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Unpick All")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    lrecSalesTaxDoc: Record "Sales Tax Documents1";
                begin
                    IF gboolActivateFilter THEN BEGIN
                        lrecSalesTaxDoc.SETRANGE("Tax-Document Post", gOptTaxDocPost);
                        lrecSalesTaxDoc.SETRANGE("Tax Type", gOptTaxType);
                        lrecSalesTaxDoc.SETRANGE("Document Type", gOptDocType);
                        IF gcodeCustNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Sell-to Customer No.", gcodeCustNo);
                        IF gcodeTaxNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Tax No.", gcodeTaxNo);
                        IF gcodeDocNo <> '' THEN lrecSalesTaxDoc.SETFILTER("No.", gcodeDocNo);
                    END;
                    lrecSalesTaxDoc.CopyFilters(Rec);
                    IF lrecSalesTaxDoc.FINDSET() THEN
                        REPEAT
                            lrecSalesTaxDoc.Pick := FALSE;
                            lrecSalesTaxDoc.MODIFY();
                        UNTIL lrecSalesTaxDoc.NEXT = 0;
                    CurrPage.UPDATE();
                end;
            }
            action("Generate Tax No.")
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction();
                var
                    lrecSalesTaxDoc: Record "Sales Tax Documents1";
                    lRecMIISetup: record "MII Setup";
                    //NoSeriesMgt: Codeunit NoSeriesManagement;
                    NoSeries: Codeunit "No. Series";
                begin
                    lrecSalesTaxDoc.RESET();
                    lrecSalesTaxDoc.SETRANGE(Pick, TRUE);
                    lrecSalesTaxDoc.SETRANGE("Document Type", lrecSalesTaxDoc."Document Type"::Invoice);
                    lrecSalesTaxDoc.SETRANGE("Tax No.", '');
                    IF lrecSalesTaxDoc.FINDSET() THEN
                        REPEAT
                            lRecMIISetup.Get();
                            lRecMIISetup.TestField("Tax Nos.");
                            //lrecSalesTaxDoc."Tax No." := NoSeriesMgt.GetNextNo(lRecMIISetup."Tax Nos.", lrecSalesTaxDoc."Posting Date", true);
                            lrecSalesTaxDoc."Tax No." := NoSeries.GetNextNo(lRecMIISetup."Tax Nos.", lrecSalesTaxDoc."Posting Date", true);
                        UNTIL lrecSalesTaxDoc.NEXT = 0;
                end;
            }
            action("Export Pajak Keluaran")
            {
                ApplicationArea = All;
                Caption = 'Export E-Faktur';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                //RunObject = report "Export Pajak Keluaran";
                trigger OnAction();
                var
                    lRecSalesTax: Record "Sales Tax Documents1";
                begin

                    lRecSalesTax.COPYFILTERS(Rec);
                    lRecSalesTax.SetRange(Pick, true);
                    IF lRecSalesTax.FINDFIRST THEN REPORT.RUN(Report::"Purchase - Invoice", TRUE, TRUE, lRecSalesTax);

                end;
            }
            action("Export Retur Pajak Keluaran")
            {
                ApplicationArea = All;
                Caption = 'Export E-Faktur Retur';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;


                trigger OnAction();
                var
                    lRecSalesTax: Record "Sales Tax Documents1";
                begin
                end;
            }
            action("Edit Pajak Keluaran")
            {
                ApplicationArea = All;
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Edit Pajak Keluaran";
                RunPageLink = "No." = field("No.");
            }
            action("Assign Faktur Pajak")
            {
                ApplicationArea = All;
                Caption = 'Assign Faktur Pajak';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GeneratePajakRec: Record "Table View Generate Header";
                    SalesTaxDocRec: Record "Sales Tax Documents1";
                    FakturNo: Code[20];
                begin

                    GeneratePajakRec.SETFILTER("Faktur Pajak ID", '<>%1', '');
                    IF GeneratePajakRec.FINDFIRST THEN BEGIN
                        FakturNo := GeneratePajakRec."Faktur Pajak ID";


                        SalesTaxDocRec.SETRANGE("Document No", Rec."Document No");
                        IF SalesTaxDocRec.FINDFIRST THEN BEGIN
                            SalesTaxDocRec."Faktur Pajak No" := FakturNo;
                            SalesTaxDocRec.MODIFY();
                            MESSAGE('Faktur Pajak No. %1 berhasil di-assign ke Document No. %2', FakturNo, Rec."Document No");
                        END ELSE BEGIN
                            ERROR('Document No %1 tidak ditemukan.', Rec."Document No");
                        END;
                    END ELSE BEGIN
                        ERROR('Tidak ada Faktur Pajak yang tersedia untuk di-assign.');
                    END;
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        lrecSalesTaxDoc: Record "Sales Tax Documents1";
    begin
        gdecDocAmount := 0;
        gdecDocAmountInclVAT := 0;
        lrecSalesTaxDoc.RESET();
        lrecSalesTaxDoc.SETRANGE("Document Type", Rec."Document Type");
        lrecSalesTaxDoc.SETRANGE("No.", Rec."No.");
        IF lrecSalesTaxDoc.FINDSET() THEN BEGIN
            lrecSalesTaxDoc.CALCFIELDS("Amount Invoice", "Amount Credit Memo", "Amount Incl. VAT Invoice", "Amount Incl. VAT Credit Memo");
            IF lrecSalesTaxDoc."Document Type" = lrecSalesTaxDoc."Document Type"::"Credit Memo" THEN BEGIN
                gdecDocAmount := (lrecSalesTaxDoc."Amount Invoice" + lrecSalesTaxDoc."Amount Credit Memo") * -1;
                gdecDocAmountInclVAT := (lrecSalesTaxDoc."Amount Incl. VAT Invoice" + lrecSalesTaxDoc."Amount Incl. VAT Credit Memo") * -1;
            END ELSE BEGIN
                gdecDocAmount := lrecSalesTaxDoc."Amount Invoice" + lrecSalesTaxDoc."Amount Credit Memo";
                gdecDocAmountInclVAT := lrecSalesTaxDoc."Amount Incl. VAT Invoice" + lrecSalesTaxDoc."Amount Incl. VAT Credit Memo";
            END;
        END;

        Rec.CalcFields(Amount, "Amount Including VAT");
        VATAmount := Rec."Amount Including VAT" - Rec.Amount;
    end;

    trigger OnOpenPage();
    begin
        fUpdateData();
    end;

    var
        gOptTaxType: Option Retail,"Tax Document","Non Tax";
        gOptDocType: Option Invoice,"Credit Memo";
        gOptTaxDocPost: Option Post,Batch,Prompt;
        gboolActivateFilter: Boolean;
        gboolCanceledDoc: Boolean;
        gboolCalc0VAT: Boolean;
        gBoolCanceled: Boolean;
        gcodeDocNo: Code[30];
        gcodeTaxNo: Code[30];
        gcodeCustNo: Code[30];
        gdecTotalAmount: Decimal;
        gdecTotalAmountInclVAT: Decimal;
        gdecDocAmount: Decimal;
        gdecDocAmountInclVAT: Decimal;
        VATAmount: Decimal;

    local procedure fUpdateData();
    begin
        Rec.RESET;
        IF gboolActivateFilter THEN BEGIN
            Rec.FILTERGROUP(2);
            // Rec.SETRANGE("Tax-Document Post", gOptTaxDocPost);
            // Rec.SETRANGE("Tax Type", gOptTaxType);
            Rec.SETRANGE("Document Type", gOptDocType);
            IF gcodeCustNo <> '' THEN Rec.SETFILTER("Sell-to Customer No.", gcodeCustNo);
            IF gcodeTaxNo <> '' THEN Rec.SETFILTER("Tax No.", gcodeTaxNo);
            IF gcodeDocNo <> '' THEN Rec.SETFILTER("No.", gcodeDocNo);
            Rec.FILTERGROUP(0);
        END;
        fCalculateTotal();
        CurrPage.UPDATE(FALSE);
    end;

    local procedure fUpdateSalesInvHeader(pcodeDocNo: Code[30]; pcodeTaxNo: Code[30]);
    var
        lrecSalesInvHeader: Record "Sales Invoice Header";
    begin
        lrecSalesInvHeader.RESET();
        lrecSalesInvHeader.SETFILTER("No.", pcodeDocNo);
        IF lrecSalesInvHeader.FINDSET() THEN BEGIN
        END;
    end;

    local procedure fCalculateTotal();
    var
        lrecSalesTaxDoc: Record "Sales Tax Documents1";
    begin
        gdecTotalAmount := 0;
        gdecTotalAmountInclVAT := 0;
        lrecSalesTaxDoc.RESET();
        IF gboolActivateFilter THEN BEGIN
            // lrecSalesTaxDoc.SETRANGE("Tax-Document Post", gOptTaxDocPost);
            // lrecSalesTaxDoc.SETRANGE("Tax Type", gOptTaxType);
            lrecSalesTaxDoc.SETRANGE("Document Type", gOptDocType);
            IF gcodeCustNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Sell-to Customer No.", gcodeCustNo);
            IF gcodeTaxNo <> '' THEN lrecSalesTaxDoc.SETFILTER("Tax No.", gcodeTaxNo);
            IF gcodeDocNo <> '' THEN lrecSalesTaxDoc.SETFILTER("No.", gcodeDocNo);
        END;
        IF lrecSalesTaxDoc.FINDSET() THEN
            REPEAT
                lrecSalesTaxDoc.CALCFIELDS("Amount Invoice", "Amount Credit Memo", "Amount Incl. VAT Invoice", "Amount Incl. VAT Credit Memo");
                IF lrecSalesTaxDoc."Document Type" = lrecSalesTaxDoc."Document Type"::Invoice THEN BEGIN
                    gdecTotalAmount := gdecTotalAmount + (lrecSalesTaxDoc."Amount Invoice" + lrecSalesTaxDoc."Amount Credit Memo");
                    gdecTotalAmountInclVAT := gdecTotalAmountInclVAT + (lrecSalesTaxDoc."Amount Incl. VAT Invoice" + lrecSalesTaxDoc."Amount Incl. VAT Credit Memo");
                END
                ELSE BEGIN
                    gdecTotalAmount := gdecTotalAmount + ((lrecSalesTaxDoc."Amount Invoice" + lrecSalesTaxDoc."Amount Credit Memo") * -1);
                    gdecTotalAmountInclVAT := gdecTotalAmountInclVAT + ((lrecSalesTaxDoc."Amount Incl. VAT Invoice" + lrecSalesTaxDoc."Amount Incl. VAT Credit Memo") * -1);
                END;
            UNTIL lrecSalesTaxDoc.NEXT = 0;
    end;
}
