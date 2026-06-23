codeunit 70101 WHTSales
{
    Permissions = TableData "WHT Buss Posting Group" = rimd,
                  TableData "WHT Product Posting Group" = rimd,
                  TableData "Sales Line" = rimd,
                  TableData "Sales Header" = rimd,
                  TableData "Sales Invoice Line" = rimd,
                  TableData "Sales Invoice Header" = rimd,
                  TableData "WHT Posting Setup" = rimd;
    TableNo = "WHT Entry";
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPrepareLineOnAfterFillInvoicePostingBuffer', '', false, false)]
    procedure copyWHtLine(var InvoicePostingBuffer: Record "Invoice Posting Buffer"; SalesLine: Record "Sales Line")
    begin
        InvoicePostingBuffer."WHT %" := SalesLine."WHT %";
        InvoicePostingBuffer."WHT Bus. Posting Group" := SalesLine."WHT Business Posting Group";
        InvoicePostingBuffer."WHT Prod. Posting Group" := SalesLine."WHT Product Posting Group";
        InvoicePostingBuffer."WHT Amount" := SalesLine."WHT Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    procedure copyinvoicetogjline(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean)
    begin
        GenJnlLine."WHT %" := TempInvoicePostingBuffer."WHT %";
        GenJnlLine."WHT Business Posting Group" := TempInvoicePostingBuffer."WHT Bus. Posting Group";
        GenJnlLine."WHT Product Posting Group" := TempInvoicePostingBuffer."WHT Prod. Posting Group";
        GenJnlLine."WHT Amount" := TempInvoicePostingBuffer."WHT Amount";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    procedure copyitemtosl(var SalesLine: Record "Sales Line"; Item: Record Item; SalesHeader: Record "Sales Header"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    begin
        SalesLine."WHT Product Posting Group" := item."WHT Product Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]
    procedure copyshtosl(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    begin
        SalesLine."WHT Business Posting Group" := SalesHeader."WHT Business Posting Group";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeValidateLocationCode', '', false, false)]
    procedure copyvendtoph(var SalesHeader: Record "Sales Header"; var Cust: Record Customer; var IsHandled: Boolean; xSalesHeader: Record "Sales Header")
    begin
        SalesHeader."WHT Business Posting Group" := Cust."WHT Business Posting Group"
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnAfterUpdateUnitPrice', '', false, false)]
    procedure calculatewht(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    var
        whtsetup: Record "WHT Posting Setup";
    begin
        whtsetup.SetFilter("WHT Business Posting Group", '%1', SalesLine."WHT Business Posting Group");
        whtsetup.SetFilter("WHT Product Posting Group", '%1', SalesLine."WHT Product Posting Group");
        if whtsetup.FindFirst() then begin
            SalesLine."WHT %" := whtsetup."WHT %";
            SalesLine."WHT Amount" := Round((SalesLine."Line Amount" * whtsetup."WHT %") / 100);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostGLAcc', '', false, false)]
    procedure PostWHTSales(var GenJnlLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup"; var TempGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link" temporary)
    var
        GJPost: Codeunit "Gen. Jnl.-Post Line";
        whtsetup: Record "WHT Posting Setup";
    begin
        if GenJnlLine."WHT Amount" <> 0 then begin
            if GenJnlLine."Source Code" <> 'SALES' then begin
                exit
            end;
            WHTEntry.Init();
            WHTEntry.CopyFromGenJnlLine(GenJnlLine);
            WHTEntry.Insert(true);
            whtsetup.SetFilter("WHT Business Posting Group", '%1', GenJnlLine."WHT Business Posting Group");
            whtsetup.SetFilter("WHT Product Posting Group", '%1', GenJnlLine."WHT Product Posting Group");
            if whtsetup.FindFirst() then begin
                LastEntryNo := NextEntryNo;
                GJPost.InitGLEntry(GenJnlLine, GLEntry, whtsetup."Receivable WHT Account Code", GenJnlLine."WHT Amount", GenJnlLine."WHT Amount", true, true, GenJnlLine."WHT Amount");
                GLEntry."Entry No." := LastEntryNo;
                GLEntry.Amount := GLEntry.Amount;
                GLEntry."Source Currency Amount" := GLEntry."Source Currency Amount";
                TempGLEntryBuf := GLEntry;
                TempGLEntryBuf.Insert();
                NextEntryNo := NextEntryNo + 1;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterIncrAmount', '', false, false)]
    local procedure TotalWHT(var TotalSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        TotalSalesLine."WHT Amount" += SalesLine."WHT Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    procedure TotalWithWHT(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; SuppressCommit: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        if TotalSalesLine."WHT Amount" <> 0 then begin
            GenJnlLine.Amount := -(TotalSalesLine."Amount Including VAT" + TotalSalesLine."WHT Amount");
            GenJnlLine."WHT Amount" := TotalSalesLine."WHT Amount";
        end;
    end;

    var
        TempWHT: Record "WHT Entries" temporary;
        WHTEntry: Record "WHT Entries";
        LastEntryNo: Integer;

}