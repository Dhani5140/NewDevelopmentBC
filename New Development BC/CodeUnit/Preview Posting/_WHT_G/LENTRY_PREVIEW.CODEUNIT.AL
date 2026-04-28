// codeunit 51159 "WHT Subscribers3"
// {
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
//     local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
//     begin
//         if not GuiAllowed then
//             exit;
//         ProcessWHT(PurchaseHeader);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnBeforePostLines', '', false, false)]
//     local procedure OnBeforePostLines(PurchHeader: Record "Purchase Header"; var TempInvoicePostingBuffer: Record "Invoice Posting Buffer" temporary)
//     begin
//         ProcessWHT(PurchHeader);
//     end;

//     local procedure ProcessWHT(var PurchaseHeader: Record "Purchase Header")
//     var
//         PurchLine: Record "Purchase Line";
//         WHTPost: Codeunit "Post WHT";
//         GenJournalLine: Record "Gen. Journal Line";
//         TempGLEntry: Record "G/L Entry" temporary;
//         WHTSetup: Record "WHT Posting Setup";
//         GLEntry: Record "G/L Entry";
//     begin
//         PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
//         PurchLine.SetRange("Document No.", PurchaseHeader."No.");

//         if not PurchLine.FindSet() then begin
//             MESSAGE('No purchase lines found for document %1', PurchaseHeader."No.");
//             exit;
//         end;

//         // Loop through each purchase line and process WHT
//         repeat
//             // Convert to General Journal Line
//             ConvertToGenJournalLine(PurchLine, GenJournalLine);

//             // Create temporary G/L Entry for WHT
//             TempGLEntry.Init();
//             TempGLEntry."Entry No." := GetNextEntryNo();
//             TempGLEntry."Posting Date" := GenJournalLine."Posting Date";
//             TempGLEntry."Document Type" := GenJournalLine."Document Type";
//             TempGLEntry."Document No." := GenJournalLine."Document No.";

//             // Get WHT Account
//             if not GetWHTAccount(WHTSetup) then begin
//                 MESSAGE('WHT Account not found in setup');
//                 exit;
//             end;

//             TempGLEntry."G/L Account No." := WHTSetup."Payable WHT Account Code"; // Custom WHT account
//             TempGLEntry.Description := 'WHT Entry';

//             // Calculate WHT Amount
//             TempGLEntry.Amount := CalculateWHTAmount(PurchLine.Amount);
//             if TempGLEntry.Amount = 0 then begin
//                 MESSAGE('WHT amount is zero for Purchase Line %1', PurchLine."Line No.");
//                 exit;
//             end;

//             // Insert the temporary G/L Entry
//             TempGLEntry.Insert();

//             // Debug: Ensure G/L Entry inserted
//             MESSAGE('Temporary G/L Entry created: Entry No. %1, Amount: %2', TempGLEntry."Entry No.", TempGLEntry.Amount);

//             // Now insert into permanent G/L Entry (this simulates posting the entry)
//             GLEntry.Init();
//             GLEntry := TempGLEntry; // Transfer to G/L Entry record
//             GLEntry.Insert(true); // Insert as a permanent record
//             MESSAGE('Permanent G/L Entry created: Entry No. %1, Amount: %2', GLEntry."Entry No.", GLEntry.Amount);

//         until PurchLine.Next() = 0;
//     end;

//     local procedure GetNextEntryNo(): Integer
//     var
//         GLEntry: Record "G/L Entry";
//     begin
//         if GLEntry.FindLast() then
//             exit(GLEntry."Entry No." + 1);
//         exit(1); // Starting entry number
//     end;

//     local procedure CalculateWHTAmount(BaseAmount: Decimal): Decimal
//     var
//         WHTSetup: Record "WHT Posting Setup";
//     begin
//         if WHTSetup.FindFirst() then
//             exit(BaseAmount * WHTSetup."WHT %" / 100);
//         exit(0); // Return zero if WHT Setup not found
//     end;

//     local procedure GetWHTAccount(var WHTSetup: Record "WHT Posting Setup"): Boolean
//     begin
//         if WHTSetup.FindFirst() then begin
//             exit(true);
//         end;
//         exit(false);
//     end;

//     local procedure ConvertToGenJournalLine(PurchLine: Record "Purchase Line"; var GenJournalLine: Record "Gen. Journal Line")
//     var
//         LastGenJournalLine: Record "Gen. Journal Line";
//         NextLineNo: Integer;
//     begin
//         // Find the last Line No. for the same journal template and batch
//         LastGenJournalLine.Reset();
//         LastGenJournalLine.SetRange("Journal Template Name", 'GENERAL');
//         LastGenJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
//         if LastGenJournalLine.FindLast() then
//             NextLineNo := LastGenJournalLine."Line No." + 10000
//         else
//             NextLineNo := 10000;

//         GenJournalLine.Init();
//         GenJournalLine."Journal Template Name" := 'GENERAL';
//         GenJournalLine."Journal Batch Name" := 'DEFAULT';
//         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
//         GenJournalLine."Account No." := PurchLine."Buy-from Vendor No.";
//         GenJournalLine.Amount := PurchLine.Amount;
//         GenJournalLine."Document No." := PurchLine."Document No.";
//         GenJournalLine."Posting Date" := WorkDate();
//         GenJournalLine."Line No." := NextLineNo;
//         GenJournalLine.Insert(true);
//     end;
// }
