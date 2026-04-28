pageextension 80000 user extends "User Settings"
{
    layout
    {
        modify("Work Date")
        {
            Visible = false;
        }
        addafter("Work Date")
        {
            field(date; date)
            {
                Caption = 'Work Date';
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    Rec."Work Date" := date;
                    Rec.Modify();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        date := rec."Work Date";
    end;

    var
        date: Date;
}