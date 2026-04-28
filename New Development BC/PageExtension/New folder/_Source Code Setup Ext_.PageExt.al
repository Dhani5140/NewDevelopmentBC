pageextension 80136 "Source Code Setup Ext" extends "Source Code Setup"
{
    layout
    {
        addafter("Invt. Shipment")
        {
            field("Inventory Shipment"; Rec."Inventory Shipment")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the inventory shipment custom.';
            }
            field("Item Consumption"; Rec."Item Consumption")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the item consumption.';
            }
        }
    }
    var
        myInt: Integer;
}
