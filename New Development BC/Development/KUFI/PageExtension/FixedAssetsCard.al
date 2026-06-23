pageextension 70013 PgExtFACard extends "Fixed Asset Card"
{
    layout
    {
        modify(BookValue)
        {
            Visible = false;
        }

        addafter(DepreciationEndingDate)
        {
            field(BookValue1; BookValue1)
            {
                ApplicationArea = FixedAssets;
                Caption = 'Book Value';
                DrillDown = true;
                Editable = false;
                ToolTip = 'Specifies the book value for the fixed asset.';

                trigger OnDrillDown()
                begin
                    FADepreciationBook.DrillDownOnBookValue();
                end;
            }
        }


        addafter("Last Date Modified")
        {
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BookValue1 := FADepreciationBook."Book Value";
    end;

    var
        BookValue1: Decimal;
}