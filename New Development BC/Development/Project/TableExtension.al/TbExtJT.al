tableextension 70102 MIIJT extends "Job Task"
{
    fields
    {
        field(70100; EndDate; Date)
        {
            CalcFormula = min("Job Planning Line".EndDate where("Job No." = field("Job No."), "Job Task No." = field("Job Task No.")));
            Caption = 'End Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70101; duration; Integer)
        {
            CalcFormula = min("Job Planning Line".duration where("Job No." = field("Job No."), "Job Task No." = field("Job Task No.")));
            Caption = 'Duration';
            Editable = false;
            FieldClass = FlowField;
        }
    }

}