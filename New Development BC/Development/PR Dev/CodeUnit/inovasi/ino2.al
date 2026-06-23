
// codeunit 50231 "Copilot Parser"
// {
//     procedure ProcessPrompt(PromptText: Text)
//     var
//         CopilotMgt: Codeunit "Copilot Mgt.";
//         CustomerNo: Code[20];
//         ItemNo: Code[20];
//         Quantity: Decimal;
//         QuantityAsText: Text;
//         Words: List of [Text];
//         i: Integer;
//     begin
//         PromptText := PromptText.ToLower();
//         Words := PromptText.Split(' ');


//         if PromptText.Contains('sales order') then begin
//             for i := 1 to Words.Count() do begin
//                 if (Words.Get(i) = 'customer') and (i < Words.Count()) then
//                     CustomerNo := DelChr(Words.Get(i + 1), '=', '.,;');

//                 if (Words.Get(i) = 'item') and (i < Words.Count()) then
//                     ItemNo := DelChr(Words.Get(i + 1), '=', '.,;');


//                 if (Words.Get(i) = 'qty') or (Words.Get(i) = 'quantity') then
//                     if i < Words.Count() then
//                         QuantityAsText := DelChr(Words.Get(i + 1), '=', '.,;');
//             end;

//             if (CustomerNo = '') or (ItemNo = '') or (QuantityAsText = '') then
//                 Error('Perintah tidak lengkap. Pastikan Anda menyertakan kata kunci "customer", "item", dan "qty".');

//             if not Evaluate(Quantity, QuantityAsText) then
//                 Error('Format kuantitas "%1" tidak valid.', QuantityAsText);


//             CopilotMgt.CreateSalesOrder(CustomerNo, ItemNo, Quantity);
//             exit;
//         end;

//         Error('Maaf, saya tidak mengerti perintah tersebut. Saya hanya bisa membuat "sales order".');
//     end;
// }
