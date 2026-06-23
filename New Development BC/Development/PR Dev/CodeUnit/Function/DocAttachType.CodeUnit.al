namespace PR;

using PR.PB;
using Microsoft.Foundation.Attachment;

codeunit 50400 DocAttachType
{
    Permissions = TableData "PBHeader" = rimd,
                  Tabledata "Material Req. Header" = rimd,
                  tabledata "PR Material Header" = rimd,
                  tabledata "RFQ Header" = RIMD,
                  tabledata "Vensel Header" = RIMD;


    [EventSubscriber(ObjectType::Page, 1178, 'OnAfterGetRecRefFail', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        PBHeader: Record PBHeader;
        MR: Record "Material Req. Header";
        PR: Record "PR Material Header";
        RFQ: Record "RFQ Header";
        VENSEL: Record "Vensel Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::PBHeader:
                begin
                    RecRef.Open(DATABASE::PBHeader);
                    if PBHeader.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PBHeader);
                end;
            Database::"Material Req. Header":
                begin
                    recref.Open(Database::"Material Req. Header");
                    if MR.GET(DocumentAttachment."No.") then
                        RECREF.GetTable(MR);
                end;
            Database::"PR Material Header":
                begin
                    RecRef.Open(Database::"PR Material Header");
                    IF MR.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PR);
                end;
            Database::"RFQ Header":
                begin
                    RecRef.Open(Database::"RFQ Header");
                    IF RFQ.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(RFQ);
                end;
            Database::"Vensel Header":
                begin
                    RecRef.Open(Database::"Vensel Header");
                    IF VENSEL.GET(DocumentAttachment."No.") then
                        RecRef.GetTable(VENSEL);
                end;
        end;


    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::PBHeader:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Material Req. Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"PR Material Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"RFQ Header":
                BEGIN
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                END;
            Database::"Vensel Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::PBHeader:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"Material Req. Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"PR Material Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"RFQ Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"Vensel Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;


}