pageextension 50129 "BankAccListExt" extends "Bank Account List"
{
    actions
    {
        addafter("Bank Account Statements")
        {
            action("Cash Flow by Account")
            {
                ApplicationArea = All;
                Caption = 'Cash Flow by Account';
                ToolTip = 'Run the Cash Flow by Account report.';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    BankAccount.Copy(Rec);
                    Report.Run(Report::"Cash Flow by Account", true, false, BankAccount);
                end;
            }
        }
    }
}