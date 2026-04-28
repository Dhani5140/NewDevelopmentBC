codeunit 80115 "PR Consignment Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_PRCons(VAR ParRec: Record "PR Consignment Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_PRCons(VAR ParRec: Record "PR Consignment Header");
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "PR Consignment Header"): Boolean
    var
        lRec: Record "PR Consignment Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure IsEnabled_Custom(var ParRec: Record "PR Consignment Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_PRCons()))
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a Purchase Request Consignment is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a Purchase Request Consignment is canceled';
        PendingApprovalMsg: Label 'An approval request for a Purchase Purchase Consignment has been sent';
        DocReleasedlMsg: Label 'Purchase Request Consignment is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
