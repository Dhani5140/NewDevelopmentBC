pageextension 80127 "Item Journal Ext" extends "Item Journal"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("Material Req. No."; Rec."Material Req. No.")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
            field("MR Usage Category"; Rec."MR Usage Category")
            {
                ApplicationArea = All;
                Editable = TRUE;
            }
            field("Unit Group"; Rec."Unit Group")
            {
                ApplicationArea = All;
                Editable = FALSE;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Get Material Req.")
            {
                Caption = 'Get Material Request';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    lRecMRLinePage: Record "Material Req. Line";
                    lRecMRLine: Record "Material Req. Line";
                    lRecMSISetup: Record "MII Setup";
                    lPageSelectMR: Page "Select MR Line";
                    ItemJournalDocNo: Code[20];
                begin
                    lRecMSISetup.RESET;
                    lRecMSISetup.GET();
                    lRecMSISetup.TestField("Item Journal Document Nos");
                    lRecMRLinePage.RESET;
                    lRecMRLinePage.SETFILTER(Quantity, '>%1', 0);
                    lRecMRLinePage.SETFILTER("Outstanding Quantity", '>%1', 0);
                    lRecMRLinePage.SETFILTER(Status, '%1|%2', lRecMRLinePage.Status::Released, lRecMRLinePage.Status::Processed);
                    lRecMRLinePage.SETRANGE(Cancel, FALSE);
                    lRecMRLinePage.SETRANGE("PPH 22", TRUE);
                    // lRecMRLinePage.SETFILTER("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                    IF lRecMRLinePage.FIND('-') THEN BEGIN
                        CLEAR(lPageSelectMR);
                        lPageSelectMR.SetTableView(lRecMRLinePage);
                        lPageSelectMR.LookupMode(true);
                        CASE lPageSelectMR.RUNMODAL() OF
                            ACTION::LookupOK:
                                BEGIN
                                    CurrPage.UPDATE();
                                    CLEAR(ItemJournalDocNo);
                                    lRecMRLine.RESET;
                                    lPageSelectMR.SetSelectionFilter(lRecMRLine);
                                    IF lRecMRLine.FIND('-') THEN BEGIN
                                        //ItemJournalDocNo := gCUNoSeriesMgt.GetNextNo(lRecMSISetup."Item Journal Document Nos", WorkDate(), true);
                                        ItemJournalDocNo := NoSeries.GetNextNo(lRecMSISetup."Item Journal Document Nos", WorkDate(), true);
                                        REPEAT
                                        //gCUMRFunct.createItemJournalLine_MR(lRecMRLine, Rec."Journal Template Name", Rec."Journal Batch Name", ItemJournalDocNo);
                                        UNTIL lRecMRLine.NEXT = 0;
                                    END;
                                END;
                        end;
                    END
                    ELSE BEGIN
                        ERROR('No Material Request Line to be get');
                    END;
                    CurrPage.UPDATE;
                end;
            }
        }
    }
    var
        gCUMRFunct: Codeunit "Material Req. Function";
        //gCUNoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
}
