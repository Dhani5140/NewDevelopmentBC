namespace PR.RFQ;
using Microsoft.Foundation.Attachment;
using Microsoft.Purchases.Vendor;
using PR.PPB;
page 60111 RfqHeader
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'RFQ Header';
    SourceTable = RFQHEADER;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = suite;
                    Importance = Promoted;
                }
                field("No.PPB"; Rec."No.PPB")
                {
                    ApplicationArea = suite;
                    Importance = Promoted;
                }

                field(Peuntukan; Rec.Peuntukan)
                {
                    Caption = 'Peruntukan';
                    Importance = Promoted;
                    ApplicationArea = suite;
                }
                field(VendorNo; Rec.VendorNo)
                {
                    Caption = 'Vendor No';
                    Importance = Promoted;
                    ApplicationArea = suite;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        vendor();
                    end;
                }

                field(vendorname; Rec.vendorname)
                {
                    Caption = 'Vendor Name';
                    Importance = Promoted;
                    ApplicationArea = Suite;
                }
                field(PYT; Rec.PYT)
                {
                    Caption = 'Payment Terms';
                    Importance = Promoted;
                    ApplicationArea = Suite;
                }
                field(EstimateDelivery; Rec.EstimateDelivery)
                {
                    Caption = 'Estimate Delivery Date';
                    Importance = Promoted;
                    ApplicationArea = suite;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    Importance = Promoted;
                    ApplicationArea = Suite;
                }
            }
            part(RFQLine; RFQLine)
            {
                SubPageLink = "No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = Suite;
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(Database::RFQHEADER),
                                "No." = field("No.");
                Visible = true;

            }
        }
    }



    actions
    {
        area(Processing)
        {
            action(Related)
            {

                ApplicationArea = Suite;
                Caption = 'Vendor Selection';
                Ellipsis = true;
                Image = Print;

                trigger OnAction()
                begin


                end;
            }

            action("Get PR Line")
            {
                Caption = 'Get PR Line';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = GetSourceDoc;

                trigger OnAction()
                var
                    PrPage: Record PPBLine;
                    PrLine: Record PPBLine;
                    GetPPb: page GetppbLine2;
                    Getdocument1: Codeunit GetDocument;
                begin
                    Rec.TestField("No.PPB");
                    PrPage.Reset;
                    PrPage.SetFilter("Document No.", Rec."No.PPB");
                    PrPage.SetRange("Document No.", Rec."No.PPB");
                    if PrPage.Find('-') then begin

                        Clear(GetPPb);
                        GetPPb.SetTableView(PrPage);
                        GetPPb.LookupMode(true);
                        case GetPPb.RunModal() of
                            ACTION::LookupOK:
                                begin
                                    CurrPage.Update();
                                    PrLine.Reset;
                                    GetPPb.SetSelectionFilter(PrLine);
                                    IF PrLine.Find('-') THEN begin
                                        repeat
                                            Getdocument1.CreateRFQLine(PrLine, Rec."No.");
                                        until PrLine.Next = 0;
                                    end;
                                end;

                        end;
                    END
                    ELSE BEGIN
                        ERROR('Ada Error');
                    END;
                    CurrPage.UPDATE;
                end;
            }



        }
        area(Reporting)
        {

            action(Doc)
            {

                ApplicationArea = Suite;
                Caption = 'Document RFQ';
                Ellipsis = true;
                Image = Print;

                trigger OnAction()
                begin
                    rec.SetRange("No.", rec."No.");
                    Report.run(60101, true, false, Rec)

                end;
            }


        }
    }
    local procedure vendor()
    var
        vendor: Record Vendor;

    begin
        vendor.SetRange("No.", rec.VendorNo);
        if vendor.FindSet() then begin
            rec.vendorname := vendor.Name;
            rec.Modify();

        end;

    end;

    VAR
        GETdocument: Codeunit GetDocument;
}