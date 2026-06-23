pageextension 70101 JT extends "Job Planning Lines"
{
    layout
    {
        addafter("Planning Date")
        {
            field(duration; Rec.duration)
            {
                Caption = 'Duration';
                ApplicationArea = all;
            }
            field(EndDate; Rec.EndDate)
            {
                ApplicationArea = all;
            }
        }
    }
}