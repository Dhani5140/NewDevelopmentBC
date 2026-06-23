pageextension 70102 JPL extends "Job Task Lines Subform"
{
    layout
    {
        modify("End Date")
        {
            Visible = false;
        }
        addafter("Start Date")
        {
            field(EndDate; Rec.EndDate)
            {
                ApplicationArea = all;
            }
        }

    }
}