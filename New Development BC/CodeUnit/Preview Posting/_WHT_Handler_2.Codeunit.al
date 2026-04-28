// // codeunit 51156 "WHT Subscribers"
// // {
// //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
// //     local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
// //     var
// //         PurchLine: Record "Purchase Line";
// //         WHTPost: Codeunit "Post WHT";
// //         GenJournalLine: Record "Gen. Journal Line";
// //     begin
// //         // Persiapkan data untuk WHT posting
// //         PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
// //         PurchLine.SetRange("Document No.", PurchaseHeader."No.");

// //         if PurchLine.FindSet() then
// //             repeat
// //                 // Konversi ke Gen. Journal Line untuk proses WHT
// //                 ConvertToGenJournalLine(PurchLine, GenJournalLine);
// //                 WHTPost.PostWHT(GenJournalLine);
// //             until PurchLine.Next() = 0;
// //     end;

// //     local procedure ConvertToGenJournalLine(PurchLine: Record "Purchase Line"; var GenJournalLine: Record "Gen. Journal Line")
// //     begin
// //         GenJournalLine.Init();
// //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
// //         GenJournalLine."Account No." := PurchLine."Buy-from Vendor No.";
// //         GenJournalLine.Amount := PurchLine.Amount;
// //         GenJournalLine."Document No." := PurchLine."Document No.";
// //         GenJournalLine."Posting Date" := WorkDate();
// //     end;
// // }
// }}}