// pageextension 51121 "WHT Preview Posting Ext" extends "Preview Posting"
// {
//     layout
//     {
//         addafter(VATEntries)
//         {
//             group("WHT Entries")
//             {
//                 field("Document No."; TempWHTEntry."Document No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Vendor No."; TempWHTEntry."Vendor No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("WHT Amount"; TempWHTEntry.Amount)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     var
//         TempWHTEntry: Record "WHT Entries" temporary;
// }
