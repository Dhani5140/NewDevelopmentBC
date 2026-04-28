pageextension 59100 "General Journal Import Ext" extends "General Journal"
{
    actions
    {
        addlast(processing)
        {
            action(ImportExcel)
            {
                ApplicationArea = All;
                Caption = 'Import Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import data dari file Excel ke General Journal';

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import Management";
                begin
                    ExcelImport.ImportExcelToGenJournal();
                    CurrPage.Update(false);
                end;
            }

            action(ImportCSV)
            {
                ApplicationArea = ALL;
                Caption = 'Import CSV';
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import data dari file Excel ke General Journal';

                trigger OnAction()
                var
                    CSVIMPORT: Codeunit "CSV Import Management";
                begin
                    CSVIMPORT.ImportCSVToGenJournal();
                    CurrPage.Update(false);
                end;

            }
            action(ImportExcelBatch)
            {
                ApplicationArea = All;
                Caption = 'Import Excel General';
                Image = ImportExcel;
                Visible = IsGeneralDefault;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExcelImport: Codeunit "Excel Import Management batch";
                begin
                    ExcelImport.ImportExcelToGenJournal();
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
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
        IsGeneralDefault := (Rec."Journal Template Name" = 'GENERAL') and (Rec."Journal Batch Name" = 'DEFAULT');
        CurrPage.Update(false);
    end;
}
