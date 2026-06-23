pageextension 70003 MIIPEextCustLedger extends "Customer Ledger Entries"
{

    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Apply Entries")
        {
            action(TransferData)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Data';
                Ellipsis = true;
                Image = TransferToGeneralJournal;
                ToolTip = 'Transfer Data';
                Promoted = true;

                trigger OnAction()
                var
                    MIICU: Codeunit MIICUSchedule;
                begin
                    MIICU.CopytoOtherCompany(Rec);
                end;
            }
            action(AutoApplied)
            {
                ApplicationArea = Basic;
                Caption = 'Auto Applied';
                Ellipsis = true;
                Image = ApplyEntries;
                ToolTip = 'Auto Applied';
                Promoted = true;

                trigger OnAction()
                var
                    Applied: Codeunit AppliedLedger;
                    Custled: Record "Cust. Ledger Entry";
                begin
                    Applied.AppliesEntries(Rec);
                    Custled.SetFilter("Document No.", '%1', Rec."Document No.");
                    if Custled.FindFirst() then begin
                        Applied.PostDirectApplication(Custled, false);
                    end
                end;
            }
            action(PreviewApplied)
            {
                ApplicationArea = Basic;
                Caption = 'Preview Auto Applied';
                Ellipsis = true;
                Image = ApplyEntries;
                ToolTip = 'Preview Auto Applied';
                Promoted = true;

                trigger OnAction()
                var
                    Applied: Codeunit AppliedLedger;
                    Custled: Record "Cust. Ledger Entry";
                begin
                    Applied.AppliesEntries(Rec);
                    Custled.SetFilter("Document No.", '%1', Rec."Document No.");
                    if Custled.FindFirst() then begin
                        Applied.PostDirectApplication(Custled, true);
                    end
                end;
            }
            // action(DeleteData)
            // {
            //     ApplicationArea = Basic;
            //     Caption = 'Delete Data';
            //     Ellipsis = true;
            //     Image = Delete;
            //     ToolTip = 'Delete Data';

            //     trigger OnAction()
            //     var
            //         MIICU: Codeunit MIICUSchedule;
            //     begin
            //         MIICU.deleteCLE(Rec);
            //     end;
            // }
        }
    }
}