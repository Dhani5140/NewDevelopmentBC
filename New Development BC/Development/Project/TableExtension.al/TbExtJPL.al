tableextension 70101 MIIJPL extends "Job Planning Line"
{
    fields
    {
        field(70100; duration; Integer)
        {
            trigger OnValidate()
            begin
                Rec.EndDate := Rec."Planning Date" + (duration - 1);
            end;
        }
        field(70101; EndDate; Date)
        {
            Caption = 'Planning Ending Date';
        }
    }

}