page 50199 Table113
{
    PageType = List;
    ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Incoming Document Attachment";
    DeleteAllowed = true;
    Permissions = TableData "Incoming Document Attachment" = rmid;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; Rec.Name)
                {

                }
                field("Created Date-Time"; rec."Created Date-Time")
                {

                }
                field("Created By User Name"; Rec."Created By User Name")
                {

                }
                field(Type; rec.Type)
                {

                }

            }


        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                var
                    RecRef: RecordRef;
                begin

                    RecRef.GetTable(Rec);
                    RecRef.Delete();
                    Message('Record deleted successfully.');
                end;

            }

        }
    }

    var
        myInt: Integer;
}