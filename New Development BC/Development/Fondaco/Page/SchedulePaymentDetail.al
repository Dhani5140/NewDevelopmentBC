page 70002 SchedulePaymentLine
{
    Caption = 'Schedule Payment Detail';
    PageType = ListPart;
    SourceTable = MiiTabScheduleLine;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
                field(Post; Rec.Post)
                {
                    ApplicationArea = Suite;
                    trigger OnValidate()
                    begin
                        if Rec.Status <> Rec.Status::Open then
                            Error('Expected status Open, but found %1', Rec.Status);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

}