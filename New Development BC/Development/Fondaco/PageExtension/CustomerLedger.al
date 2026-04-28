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