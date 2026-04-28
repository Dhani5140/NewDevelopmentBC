pageextension 80129 "Payment Journal Ext" extends "Payment Journal"
{
    actions
    {
        addfirst(Reporting)
        {
            action("Print Bukti Bank Keluar")
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = True;
                PromotedCategory = Report;
                PromotedIsBig = TRUE;

                trigger OnAction()
                var
                    lRec: Record "Gen. Journal Line";
                begin
                    Rec.TestField(Rec."Document No.");
                    lRec.RESET;
                    lRec.SETRANGE(lRec."Journal Template Name", Rec."Journal Template Name");
                    lRec.SETRANGE(lRec."Journal Batch Name", Rec."Journal Batch Name");
                    lRec.FilterGroup(2);
                    lRec.SETRANGE(lRec."Line No.", Rec."Line No.");
                    lRec.FilterGroup(0);
                    lRec.SETRANGE(lRec."Document No.", Rec."Document No.");

                end;
            }
            action(ImportExcelBatch)
            {
                ApplicationArea = all;
                Caption = 'Import Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import payment journal";
                begin
                    ExcelImport.ImportExcelToGenJournal();
                    CurrPage.Update(false);

                end;
            }
        }
    }
    var
        myInt: Integer;
        IsGeneralDefault: Boolean;

    trigger OnAfterGetRecord()
    begin
        SetActionVisibility();
    end;

    trigger OnOpenPage()
    begin
        SetActionVisibility();
        CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetActionVisibility();
    end;

    local procedure SetActionVisibility()
    begin
        IsGeneralDefault := (rec."Journal Template Name" = 'PAYMENT') AND (REC."Journal Batch Name" = 'CASH');
        CurrPage.Update(false);
    end;
}
