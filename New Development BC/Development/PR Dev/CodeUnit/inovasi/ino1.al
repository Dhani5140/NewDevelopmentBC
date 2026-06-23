
// codeunit 50230 "Copilot Mgt."
// {
//     procedure CreateSalesOrder(CustomerNo: Code[20]; ItemNo: Code[20]; OrderQuantity: Decimal)
//     var
//         SalesHeader: Record "Sales Header";
//         SalesLine: Record "Sales Line";
//         Customer: Record Customer;
//         Item: Record Item;
//     begin

//         if not Customer.Get(CustomerNo) then
//             Error('Customer dengan No. %1 tidak ditemukan.', CustomerNo);

//         if not Item.Get(ItemNo) then
//             Error('Item dengan No. %1 tidak ditemukan.', ItemNo);


//         SalesHeader.Init();
//         SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
//         SalesHeader.Insert(true); // Insert untuk mendapatkan No. Dokumen
//         SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
//         SalesHeader.Modify(true);


//         SalesLine.Init();
//         SalesLine."Document Type" := SalesHeader."Document Type";
//         SalesLine."Document No." := SalesHeader."No.";
//         SalesLine."Line No." := 10000;
//         SalesLine.Validate("No.", Item."No.");
//         SalesLine.Validate(Quantity, OrderQuantity);
//         SalesLine.Insert(true);


//         Message('Inovasi Berhasil! Sales Order %1 untuk customer %2 telah dibuat.', SalesHeader."No.", Customer.Name);
//     end;
// }
