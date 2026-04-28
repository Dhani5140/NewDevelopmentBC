tableextension 70002 TbItemExt extends Item
{
    fields
    {
        field(70001; "Complimentary Item No."; Code[20])
        {
            Caption = 'Complimentary Item No.';
            TableRelation = Item."No.";
        }

        field(70002; "Complimentary Qty"; Decimal) { }

        field(70003; "Main Item Qty"; Decimal) { }

    }
}