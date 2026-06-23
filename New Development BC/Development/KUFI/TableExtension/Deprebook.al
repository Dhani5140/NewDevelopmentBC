tableextension 70019 "FA Depreciation Book Ext" extends "FA Depreciation Book"
{
    fields
    {
        field(70001; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            FieldClass = FlowField;
            CalcFormula = sum("FA Ledger Entry".Quantity where("FA No." = field("FA No."),
                                                              "Depreciation Book Code" = field("Depreciation Book Code"),
                                                              "Part of Book Value" = const(true),
                                                              "FA Posting Date" = field("FA Posting Date Filter")));
        }
        field(70002; "Acquisition Cost All"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("FA Ledger Entry".Amount where("FA No." = field("FA No."),
                                                              "Depreciation Book Code" = field("Depreciation Book Code"),
                                                              "FA Posting Type" = const("Acquisition Cost"),
                                                              "FA Posting Date" = field("FA Posting Date Filter")));
            Caption = 'Acquisition Cost All';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}