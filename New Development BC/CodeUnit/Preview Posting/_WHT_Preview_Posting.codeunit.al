// codeunit 51115 "WHT Preview"
// {
//     SingleInstance = true;
//     [EventSubscriber(ObjectType::Table, Database::"WHT Entries1", 'OnAfterInsertEvent', '', false, false)]
//     local procedure whtentries(var Rec: Record "WHT Entries1")
//     begin
//         if Rec.IsTemporary() then
//             exit;

//         PostingPreview.PreventCommit();
//         TempWHT := Rec;
//         TempWHT."Document No." := '***';
//         TempWHT.Insert();
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', false, false)]
//     local procedure FillDocumentEntry(var DocumentEntry: Record "Document Entry")
//     begin
//         PostingPreview.InsertDocumentEntry(TempWHT, DocumentEntry);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', false, false)]
//     local procedure ShowEntries(TableNo: Integer)
//     begin
//         if tableNo = Database::"WHT Entries1" then
//             Page.run(page::"WHT Entries", TempWHT)

//     end;

//     var
//         TempWHT: Record "WHT Entries1" temporary;
//         PostingPreview: Codeunit "Posting Preview Event Handler";
// }