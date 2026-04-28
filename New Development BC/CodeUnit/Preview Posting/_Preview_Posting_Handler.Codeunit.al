// codeunit 51114 "Preview Posting Handler"
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostPurchLineOnBeforeInsertReceiptLine', '', false, false)]
//     local procedure WhtEntries(PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; PreviewMode: Boolean)
//     var
//         WhtEntries: Record "WHT Entries1";
//         PostingPreviewnHandler: Codeunit "Posting Preview Event Handler";
//     begin

//         if PreviewMode Then
//             PostingPreviewnHandler.PreventCommit();

//         WhtEntries.Init();
//         WhtEntries."Document No." := PurchaseHeader."No.";
//         WhtEntries.Insert(true);

//     end;
// }