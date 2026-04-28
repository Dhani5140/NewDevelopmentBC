codeunit 80114 "MR Consignment Approval"
{
    trigger OnRun()
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendforApproval_MRCons(VAR ParRec: Record "MR Consignment Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelforApproval_MRCons(VAR ParRec: Record "MR Consignment Header");
    begin
    end;

    procedure CheckWorkflowEnabled(var ParRec: Record "MR Consignment Header"): Boolean
    var
        lRec: Record "MR Consignment Header";
    begin
        if not IsEnabled_Custom(ParRec) then Error(NoWorkflowEnb);
        exit(true);
    end;

    procedure IsEnabled_Custom(var ParRec: Record "MR Consignment Header"): Boolean
    var
        MSIWorkflow: Codeunit "MII Workflow";
    begin
        exit(WorkflowMgt.CanExecuteWorkflow(ParRec, MSIWorkflow.RunWorkflowOnSendApprovalCode_MRCons()))
    end;

    var
        NothingtoApproveErr: Label 'There is nothing to approve';
        NoWorkflowEnb: Label 'No approval workflow for this record type is enabled';
        DocSendApprovalMsg: Label 'Approval of a Material Request Consignment is requested';
        DocApprovalCanceledMsg: Label 'An approval request for a Material Request Consignment is canceled';
        PendingApprovalMsg: Label 'An approval request for a Material Request Consignment has been sent';
        DocReleasedlMsg: Label 'Material Request Consignment is released';
        WorkflowMgt: Codeunit "Workflow Management";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
}
