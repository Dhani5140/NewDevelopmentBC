pageextension 80167 "Vendor List Eval Ext" extends "Vendor List"
{
    actions
    {
        addlast(Reporting)
        {
            action("Vendor Delivery Eval")
            {
                ApplicationArea = All;
                Caption = 'Delivery Evaluation Report';
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Hitung performa ketepatan waktu pengiriman vendor ini.';

                // Menjalankan report secara spesifik untuk vendor yang sedang disorot
                trigger OnAction()
                var
                    VendorRec: Record Vendor;
                begin
                    VendorRec.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Simple Vendor Evaluation", true, false, VendorRec);
                end;
            }
        }
    }
}