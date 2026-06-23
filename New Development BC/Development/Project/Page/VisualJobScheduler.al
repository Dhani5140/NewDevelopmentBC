page 90100 "Visual Job Scheduler"
{
    PageType = Card;
    ApplicationArea = All;
    Caption = 'Visual Job Scheduler';
    UsageCategory = None;

    layout
    {
        area(content)
        {
            usercontrol(Gantt; "CustomGantt")
            {
                ApplicationArea = All;

                trigger OnControlReady()
                var
                    JsonText: Text;
                begin
                    JsonText := GetFullProjectJson(CurrentJobNo);
                    CurrPage.Gantt.LoadData(JsonText);
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportToMSProject)
            {
                Caption = 'Export to MS Project';
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                begin
                    MSProjectExport.ExportProject(CurrentJobNo);
                end;
            }
        }
    }


    var
        CurrentJobNo: Code[20];
        MSProjectExport: Codeunit "MS Project Export";

    procedure SetJob(JobNo: Code[20])
    begin
        CurrentJobNo := JobNo;
    end;

    local procedure GetFullProjectJson(JobNo: Code[20]): Text
    var
        JobTask: Record "Job Task";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        StartDate: Date;
        EndDate: Date;
        JsonText: Text;
        HasDate: Boolean;
    begin
        JobTask.SetRange("Job No.", JobNo);

        if JobTask.FindSet() then
            repeat
                JobTask.CalcFields("Start Date", EndDate, duration);
                Clear(JsonObj);

                HasDate := JobTask."Start Date" <> 0D;

                if HasDate then begin
                    StartDate := JobTask."Start Date";

                    if JobTask.EndDate <> 0D then
                        EndDate := JobTask.EndDate
                    else
                        EndDate := CalcDate('<7D>', StartDate);

                    JsonObj.Add('start',
                        Format(StartDate, 0, '<Year4>-<Month,2>-<Day,2>'));
                    JsonObj.Add('end',
                        Format(EndDate, 0, '<Year4>-<Month,2>-<Day,2>'));
                end;

                JsonObj.Add('id', JobTask."Job Task No.");
                JsonObj.Add('name', JobTask.Description);
                JsonObj.Add('progress', 0);
                JsonObj.Add('hasDate', HasDate);
                JsonObj.Add('duration', JobTask.duration);

                JsonArray.Add(JsonObj);

            until JobTask.Next() = 0;

        JsonArray.WriteTo(JsonText);
        exit(JsonText);
    end;



}