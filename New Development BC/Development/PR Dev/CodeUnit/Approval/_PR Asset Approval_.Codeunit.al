codeunit 80108 "PR Asset Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_PRAsset(VAR ParRec: Record "PR Asset Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_PRAsset(VAR ParRec: Record "PR Asset Header");
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "PR Asset Header"): Boolean
    var
        lRec: Record "PR Asset Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure IsEnabled_Custom(var ParRec: Record "PR Asset Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_PRAsset()))
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a Purchase Request Asset is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a Purchase Request Asset is canceled';
        PendingApprovalMsg: Label 'An approval request for a Purchase Purchase Asset has been sent';
        DocReleasedlMsg: Label 'Purchase Request Asset is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
