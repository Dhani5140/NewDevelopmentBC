tableextension 70018 TbExtFA extends "Fixed Asset"
{
    fields
    {
        field(70001; Quantity; Decimal)
        {
            CalcFormula = sum("FA Ledger Entry".Quantity where("FA No." = field("No.")));
            FieldClass = FlowField;
        }
    }
}