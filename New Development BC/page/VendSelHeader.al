namespace PR.VSL;
USING VSL.LINE;
using PR.RFQ;
using Microsoft.Purchases.Vendor;
using PR.PPB;
page 60116 "Vendor Selection Header"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Vendor Selection Header';
    SourceTable = "Vendor Selection Header";

    layout
    {
        area(Content)
        {
            group(General)

            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Tanggal IN"; Rec."Tanggal IN")
                {
                    ApplicationArea = suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        vendor();
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                }

                field("Nomor PPB"; Rec."Nomor PPB")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'No. Purchase Request';
                }

                field(Peruntukan; Rec.Peruntukan)
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    Caption = 'Peruntukan';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Importance = Promoted;
                    ShowMandatory = true;
                }

            }
            group(List1)
            {
                part(list3; GetppbLine)
                {
                    SubPageLink = "Document No." = field("Nomor PPB");
                    ApplicationArea = Suite;
                    UpdatePropagation = Both;
                    Enabled = false;
                    Editable = false;
                }
            }
            group(list2)
            {
                part(list4; RFQLine)
                {
                    SubPageLink = "PPB Document No." = field("Nomor PPB"),
                                    "Vendor No" = field("Vendor No.");

                    ApplicationArea = suite;
                    UpdatePropagation = Both;

                }
            }



        }
    }

    actions
    {
        area(Processing)
        {
            action(transPO)
            {
                ApplicationArea = SUITE;
                Caption = 'Transfer PO';
                Ellipsis = true;
                Image = TransferOrder;

                trigger OnAction()
                begin
                    Rec.TransferPQ();
                end;
            }
        }
    }
    local procedure vendor()
    var
        vendor: Record Vendor;

    begin
        vendor.SetRange("No.", rec."Vendor No.");
        if vendor.FindSet() then begin
            rec."Vendor Name" := vendor.Name;
            rec.Modify();

        end;

    end;

}