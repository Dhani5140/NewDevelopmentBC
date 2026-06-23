page 70001 SchedulePaymentHeader
{
    Caption = 'Installment Schedule';
    DataCaptionFields = "Start Date";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Worksheet;
    ShowFilter = false;
    SourceTable = MiiTabScheduleHeader;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field("Amount to Installment"; Rec."Amount to Installment")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the amount to defer per period.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("No. of Periods"; Rec."No. of Periods")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies how many accounting periods the total amounts will be deferred to.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies when to start calculating deferral amounts.';
                }
            }
            part(DeferralSheduleSubform; SchedulePaymentLine)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CalculateSchedule)
            {
                ApplicationArea = Suite;
                Caption = 'Calculate Schedule';
                Image = CalculateCalendar;
                ToolTip = 'Calculate the installment schedule by which revenue or expense amounts will be distributed over multiple accounting periods.';

                trigger OnAction()
                var
                    schedule: Codeunit MIICUSchedule;
                    Line: Record MiiTabScheduleLine;
                begin
                    if Rec."No. of Periods" < 1 then begin
                        Error('You must specify one or more periods.');
                    end else begin
                        Line.SetRange("Document No.", Rec."Document No.");
                        Line.SetFilter(Status, '<>%1', Line.Status::Open);
                        if Line.FindSet() then begin
                            Error('You cannot recalculate Line');
                        end else begin
                            Line.Reset();
                            Line.SetRange("Document No.", Rec."Document No.");
                            if Line.FindSet() then begin
                                Line.DeleteAll();
                            end;
                        end;

                        schedule.InsertScheduleLine(Rec);
                    end;
                end;
            }
            action(Posting)
            {
                ApplicationArea = Suite;
                Caption = 'Posting Installment';
                Image = CalculateCalendar;
                ToolTip = 'Posting Installment';

                trigger OnAction()
                var
                    Line: Record MiiTabScheduleLine;
                    schedule: Codeunit MIICUSchedule;
                begin
                    Line.SetFilter("Document No.", rec."Document No.");
                    Line.SetRange(Post, true);
                    Line.SetFilter(Status, '%1', Line.Status::Open);
                    if Line.FindSet() then begin
                        schedule.updateprepayment(Line);
                    end;
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(CalculateSchedule_Promoted; CalculateSchedule)
                {
                }
                actionref(Posting_Promoted; Posting)
                {
                }
            }
        }
    }

    local procedure InsertSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    var
        NoSeries: Codeunit "No. Series";
    begin
        SalesInvHeader.Init();
        SalesInvHeader.TransferFields(SalesHeader);
        SalesInvHeader."Posting Description" := 'Installment' + SalesHeader."No.";
        SalesInvHeader."Payment Terms Code" := SalesHeader."Payment Terms Code";
        SalesInvHeader."Due Date" := SalesHeader."Due Date";
        SalesInvHeader."No." := NoSeries.GetNextNo('S-PREP');
        SalesInvHeader."User ID" := CopyStr(UserId(), 1, MaxStrLen(SalesInvHeader."User ID"));
        SalesInvHeader."No. Printed" := 0;
        SalesInvHeader."Prepayment Invoice" := true;
        SalesInvHeader."Prepayment Order No." := SalesHeader."No.";
        SalesInvHeader."No. Series" := 'S-PREP';
        SalesInvHeader.Insert();
    end;

    local procedure InsertSalesInvLine(SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; Amount: Decimal)
    var
        SalesInvLine: Record "Sales Invoice Line";
        GenPost: Record "General Posting Setup";
        GLNo: Code[20];
    begin
        GenPost.SetFilter("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
        GenPost.SetFilter("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
        if GenPost.FindFirst() then begin
            GLNo := GenPost."Sales Prepayments Account";
        end;

        SalesInvLine.Init();
        SalesInvLine."Document No." := SalesInvHeader."No.";
        SalesInvLine."Line No." := 10000;
        SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
        SalesInvLine.Type := SalesInvLine.Type::"G/L Account";
        SalesInvLine."No." := GLNo;
        SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
        SalesInvLine.Quantity := 1;
        SalesInvLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
        SalesInvLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
        SalesInvLine.Amount := Amount;
        SalesInvLine."Amount Including VAT" := Amount;
        SalesInvLine.Insert();
    end;



    trigger OnDeleteRecord(): Boolean
    begin

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

    end;

    trigger OnModifyRecord(): Boolean
    begin

    end;

    trigger OnOpenPage()
    begin

    end;


}