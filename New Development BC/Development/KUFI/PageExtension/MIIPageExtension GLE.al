pageextension 70112 MIIPgExtGLE extends "General Ledger Entries"
{
    actions
    {
        addafter(ReverseTransaction)
        {
            action(TransferData)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Data';
                Ellipsis = true;
                Image = TransferToGeneralJournal;
                ToolTip = 'Transfer Data';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Transfer: Codeunit TransferJournal;
                begin
                    Transfer.copyTemporaryGLE(Rec);
                end;
            }

        }
    }
}