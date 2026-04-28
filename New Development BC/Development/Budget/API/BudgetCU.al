codeunit 60000 MIIBudgetCU
{
    trigger OnRun()
    begin

    end;

    procedure SyncBudget(EntryNo: Integer): Text
    var
        glBudget: Record "G/L Budget Entry";
    begin
        glBudget.SetFilter("Entry No.", '%1', EntryNo);
        if glBudget.FindFirst() then begin
            glBudget.Status := glBudget.Status::Sync;
            glBudget.Modify();
            exit('Ok');
        end;
    end;
}