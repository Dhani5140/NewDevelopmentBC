// codeunit 50105 "RO TO Subscriber"
// {
//     // 1. Dengerin pas Transfer Shipment Header (Barang dikirim) dibuat
//     [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterInsertEvent', '', false, false)]
//     local procedure OnAfterInsertTransferShipment(var Rec: Record "Transfer Shipment Header"; RunTrigger: Boolean)
//     var
//         TransHeader: Record "Transfer Header";
//         MRHeader: Record "Material Req. Header";
//     begin
//         // Cari Transfer Order asalnya
//         if TransHeader.Get(Rec."Transfer Order No.") then begin
//             if TransHeader."Material Req. No." <> '' then begin
//                 if MRHeader.Get(TransHeader."Material Req. No.") then begin
//                     // Status RO jadi Processed
//                     MRHeader.Validate(Status, MRHeader.Status::Processed);
//                     MRHeader.Modify(true);
//                 end;
//             end;
//         end;
//     end;

//     // 2. Dengerin pas Transfer Receipt Header (Barang diterima) dibuat
//     [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterInsertEvent', '', false, false)]
//     local procedure OnAfterInsertTransferReceipt(var Rec: Record "Transfer Receipt Header"; RunTrigger: Boolean)
//     var
//         TransHeader: Record "Transfer Header";
//         MRHeader: Record "Material Req. Header";
//     begin
//         // Cari Transfer Order asalnya
//         if TransHeader.Get(Rec."Transfer Order No.") then begin
//             if TransHeader."Material Req. No." <> '' then begin
//                 if MRHeader.Get(TransHeader."Material Req. No.") then begin
//                     // Status RO jadi Closed
//                     MRHeader.Validate(Status, MRHeader.Status::Closed);
//                     MRHeader.Modify(true);
//                 end;
//             end;
//         end;
//     end;
// }

codeunit 50105 "RO TO Subscriber"
{
    // 1. Dengerin pas Transfer Shipment Header (Barang dikirim) dibuat
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransferShipment(var Rec: Record "Transfer Shipment Header"; RunTrigger: Boolean)
    var
        TransHeader: Record "Transfer Header";
        MRHeader: Record "Material Req. Header";
    begin
        // Cari Transfer Order asalnya
        if TransHeader.Get(Rec."Transfer Order No.") then begin
            if TransHeader."Material Req. No." <> '' then begin
                if MRHeader.Get(TransHeader."Material Req. No.") then begin
                    // Status RO jadi Processed
                    MRHeader.Validate(Status, MRHeader.Status::Processed);
                    MRHeader.Modify(true);
                end;
            end;
        end;
    end;

    // 2. Dengerin pas Transfer Receipt Header (Barang diterima) dibuat
    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransferReceipt(var Rec: Record "Transfer Receipt Header"; RunTrigger: Boolean)
    var
        TransHeader: Record "Transfer Header";
        MRHeader: Record "Material Req. Header";
    begin
        // Cari Transfer Order asalnya
        if TransHeader.Get(Rec."Transfer Order No.") then begin
            if TransHeader."Material Req. No." <> '' then begin
                if MRHeader.Get(TransHeader."Material Req. No.") then begin
                    // Status RO jadi Closed
                    MRHeader.Validate(Status, MRHeader.Status::Closed);
                    MRHeader.Modify(true);
                end;
            end;
        end;
    end;

    // 3. Update Outstanding Quantity di RO Line pas Barang di-Ship
    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure UpdateROLineOnShip(var Rec: Record "Transfer Shipment Line"; RunTrigger: Boolean)
    var
        TransHeader: Record "Transfer Header";
        MRLine: Record "Material Req. Line";
    begin
        // Cari Header TO-nya
        if TransHeader.Get(Rec."Transfer Order No.") then begin
            if TransHeader."Material Req. No." <> '' then begin

                // Cari Line RO berdasarkan RO No dan Item No
                MRLine.Reset();
                MRLine.SetRange("Material Req. No.", TransHeader."Material Req. No.");
                MRLine.SetRange("Item No.", Rec."Item No.");

                if MRLine.FindFirst() then begin
                    // Jika di Line RO ada rumus/function kalkulasi, panggil di sini
                    // Contoh: MIFunction.CalculateOutstanding(MRLine); 

                    // Jika manual update (field normal):
                    MRLine.Validate("Outstanding Quantity", MRLine."Outstanding Quantity" - Rec.Quantity);
                    MRLine.Modify(true);
                end;
            end;
        end;
    end;
}