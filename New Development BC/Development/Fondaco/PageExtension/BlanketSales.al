pageextension 70001 MIIPEextBSO extends "Blanket Sales Order"
{
    layout
    {
        addafter("Order Date")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = all;
            }

            field("Finishing Date"; Rec."Finishing Date")
            {
                ApplicationArea = all;
                Caption = 'Expiration Date';
            }
            // field(Termin; Rec.Termin)
            // {
            //     ApplicationArea = all;
            // }

        }
        addafter("Shipping and Billing")
        {
            // group(Control1900201301)
            // {
            //     Caption = 'Prepayment';
            //     field("Prepayment %"; Rec."Prepayment %")
            //     {
            //         ApplicationArea = Prepayments;
            //         Importance = Promoted;
            //         ToolTip = 'Specifies the prepayment percentage to use to calculate the prepayment for sales.';

            //         // trigger OnValidate()
            //         // begin
            //         //     //Prepayment37OnAfterValidate();
            //         // end;
            //     }
            //     field("Prepmt. Payment Terms Code"; Rec."Prepmt. Payment Terms Code")
            //     {
            //         ApplicationArea = Prepayments;
            //         ToolTip = 'Specifies the code that represents the payment terms for prepayment invoices related to the sales document.';
            //     }
            //     field("Prepayment Due Date"; Rec."Prepayment Due Date")
            //     {
            //         ApplicationArea = Prepayments;
            //         Importance = Promoted;
            //         ToolTip = 'Specifies when the prepayment invoice for this sales order is due.';
            //     }
            // }
        }
    }

    actions
    {
        modify(MakeOrder)
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            var
                SalesLine: Record "Sales Line";
            begin
                // SalesLine.SetFilter("Document No.", '%1', Rec."No.");
                // SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                // if SalesLine.FindSet() then begin
                //     repeat
                //         SalesLine."Prepmt. Line Amount" := 0;
                //     until SalesLine.Next() = 0;
                // end;
            end;
        }
        addlast(processing)
        {
            action(ScheduledPayments)
            {
                ApplicationArea = Basic;
                Caption = 'Schedule Payments';
                Ellipsis = true;
                Image = PrepaymentPost;
                ToolTip = 'Create Scheduled Payments';

                trigger OnAction()
                var
                    schedule: Codeunit MIICUSchedule;
                    Header: Record MiiTabScheduleHeader;
                begin
                    if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
                        Header.Reset();
                        Header.SetRange("Document No.", Rec."No.");
                        if not Header.FindFirst() then begin
                            schedule.InsertScheduleHeader(Rec);
                            Header.SetRange("Document No.", Rec."No.");
                            Header.FindFirst();
                        end else begin
                            Rec.CalcFields(Amount, "Amount Including VAT");
                            Header."Initial Amount Installment" := Rec.Amount;
                            Header."Amount to Installment" := Rec.Amount;
                            Header.Modify();
                        end;

                        Commit();

                        Page.RunModal(Page::SchedulePaymentHeader, Header);

                    end;
                end;
            }


            // group("Prepa&yment")
            // {
            //     Caption = 'Prepa&yment';
            //     Image = Prepayment;
            //     action("Prepayment &Test Report")
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Prepayment &Test Report';
            //         Ellipsis = true;
            //         Image = PrepaymentSimulation;
            //         ToolTip = 'Preview the prepayment transactions that will results from posting the sales document as invoiced. ';

            //         trigger OnAction()
            //         begin
            //             ReportPrint.PrintSalesHeaderPrepmt(Rec);
            //         end;
            //     }
            //     action(PostPrepaymentInvoice)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Post Prepayment &Invoice';
            //         Ellipsis = true;
            //         Image = PrepaymentPost;
            //         ToolTip = 'Post the specified prepayment information. ';

            //         trigger OnAction()
            //         var
            //             SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
            //             Prepay: Codeunit Prepay;
            //         begin
            //             if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
            //                 Rec.Validate("Prepayment %");
            //                 Prepay.Code(Rec, 0);
            //             end;
            //         end;
            //     }
            //     action("Post and Print Prepmt. Invoic&e")
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Post and Print Prepmt. Invoic&e';
            //         Ellipsis = true;
            //         Image = PrepaymentPostPrint;
            //         ToolTip = 'Post the specified prepayment information and print the related report. ';

            //         trigger OnAction()
            //         var
            //             SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
            //         begin
            //             if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
            //                 SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec, true);
            //         end;
            //     }
            //     action(PreviewPrepmtInvoicePosting)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Preview Prepmt. Invoice Posting';
            //         Image = ViewPostedOrder;
            //         ToolTip = 'Review the different types of entries that will be created when you post the prepayment invoice.';

            //         trigger OnAction()
            //         begin
            //             ShowPrepmtInvoicePreview();
            //         end;
            //     }
            //     action(PostPrepaymentCreditMemo)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Post Prepayment &Credit Memo';
            //         Ellipsis = true;
            //         Image = PrepaymentPost;
            //         ToolTip = 'Create and post a credit memo for the specified prepayment information.';

            //         trigger OnAction()
            //         var
            //             SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
            //             Prepay: Codeunit Prepay;
            //         begin
            //             if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
            //                 Prepay.Code(Rec, 1);
            //         end;
            //     }
            //     action("Post and Print Prepmt. Cr. Mem&o")
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Post and Print Prepmt. Cr. Mem&o';
            //         Ellipsis = true;
            //         Image = PrepaymentPostPrint;
            //         ToolTip = 'Create and post a credit memo for the specified prepayment information and print the related report.';

            //         trigger OnAction()
            //         var
            //             SalesPostYNPrepmt: Codeunit "Sales-Post Prepayment (Yes/No)";
            //         begin
            //             if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then
            //                 SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec, true);
            //         end;
            //     }
            //     action(PreviewPrepmtCrMemoPosting)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Preview Prepmt. Cr. Memo Posting';
            //         Image = ViewPostedOrder;
            //         ToolTip = 'Review the different types of entries that will be created when you post the prepayment credit memo.';

            //         trigger OnAction()
            //         begin
            //             ShowPrepmtCrMemoPreview();
            //         end;
            //     }
            // }
        }
        addfirst("O&rder")
        {
            action(PagePostedSalesPrepaymentInvoices)
            {
                ApplicationArea = basic;
                Caption = 'Sales Order';
                Image = SalesInvoice;
                RunObject = Page "Sales Orders";
                RunPageLink = "Blanket Order No." = field("No.");
                RunPageView = sorting("Document Type", "Blanket Order No.", "Blanket Order Line No.");
                ToolTip = 'View related sales order. ';
            }

            action(PagePostedSalesInvoices)
            {
                ApplicationArea = basic;
                Caption = 'Sales Invoice';
                Image = SalesInvoice;
                RunObject = Page "Posted Sales Invoice Lines";
                RunPageLink = "Blanket Order No." = field("No.");
                RunPageView = sorting("Blanket Order No.", "Blanket Order Line No.");
                ToolTip = 'View related sales order. ';
            }

            // group(Prepayment)
            // {
            //     Caption = 'Prepayment';
            //     Image = Prepayment;
            //     action(PagePostedSalesPrepaymentInvoices)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Prepa&yment Invoices';
            //         Image = PrepaymentInvoice;
            //         RunObject = Page "Posted Sales Invoices";
            //         RunPageLink = "Prepayment Order No." = field("No.");
            //         RunPageView = sorting("Prepayment Order No.");
            //         ToolTip = 'View related posted sales invoices that involve a prepayment. ';
            //     }
            //     action(PagePostedSalesPrepaymentCrMemos)
            //     {
            //         ApplicationArea = Prepayments;
            //         Caption = 'Prepayment Credi&t Memos';
            //         Image = PrepaymentCreditMemo;
            //         RunObject = Page "Posted Sales Credit Memos";
            //         RunPageLink = "Prepayment Order No." = field("No.");
            //         RunPageView = sorting("Prepayment Order No.");
            //         ToolTip = 'View related posted sales credit memos that involve a prepayment. ';
            //     }
            // }
        }
    }

    local procedure ShowPrepmtInvoicePreview()
    var
        SalesPostPrepaymentYesNo: Codeunit "Sales-Post Prepayment (Yes/No)";
    begin
        SalesPostPrepaymentYesNo.Preview(Rec, 2);
    end;

    local procedure ShowPrepmtCrMemoPreview()
    var
        SalesPostPrepaymentYesNo: Codeunit "Sales-Post Prepayment (Yes/No)";
    begin
        SalesPostPrepaymentYesNo.Preview(Rec, 3);
    end;


    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update();
    end;


    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
}