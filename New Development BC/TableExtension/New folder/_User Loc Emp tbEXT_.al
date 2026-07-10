pageextension 80283 "Location Card Ext MII" extends "Location Card"
{
    layout
    {
        addlast(General)
        {
            field("Default Supplying"; Rec."Default Supplying")
            {
                ApplicationArea = All;
                ToolTip = 'Pilih Central Kitchen yang akan menyuplai outlet ini.';
            }
            field("Default In-Transit"; Rec."Default In-Transit")
            {
                ApplicationArea = All;
                ToolTip = 'Pilih gudang in-transit untuk pengiriman dari CK ke outlet ini.';
            }
        }
    }
}