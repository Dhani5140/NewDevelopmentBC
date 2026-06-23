codeunit 90101 "MS Project Export"
{
    procedure ExportProject(JobNo: Code[20])
    var
        JobTask: Record "Job Task";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
        UIDCounter: Integer;
    begin
        UIDCounter := 1;

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);

        // HEADER
        OutStream.WriteText('<?xml version="1.0" encoding="UTF-8"?>');
        OutStream.WriteText('<Project xmlns="http://schemas.microsoft.com/project">');
        OutStream.WriteText('<Name>' + JobNo + '</Name>');
        OutStream.WriteText('<Tasks>');

        JobTask.SetRange("Job No.", JobNo);
        JobTask.SetCurrentKey("Job Task No.");

        if JobTask.FindSet() then
            repeat
                WriteTaskToXml(JobTask, OutStream, UIDCounter);
                UIDCounter += 1;
            until JobTask.Next() = 0;

        OutStream.WriteText('</Tasks>');
        OutStream.WriteText('</Project>');

        TempBlob.CreateInStream(InStream);
        FileName := JobNo + '_Project.xml';
        DownloadFromStream(InStream, '', '', '', FileName);
    end;

    // =====================================
    // CORE WRITER
    // =====================================

    local procedure WriteTaskToXml(
        JobTask: Record "Job Task";
        var OutStream: OutStream;
        UID: Integer)
    var
        HasDate: Boolean;
        IsMilestone: Boolean;
    begin
        HasDate := JobTask."Start Date" <> 0D;
        IsMilestone := HasDate and (JobTask."Start Date" = JobTask.EndDate);

        OutStream.WriteText('<Task>');
        OutStream.WriteText('<UID>' + Format(UID) + '</UID>');
        OutStream.WriteText('<ID>' + Format(UID) + '</ID>');
        OutStream.WriteText('<Name>' + XmlEncode(JobTask.Description) + '</Name>');
        OutStream.WriteText('<OutlineLevel>' +
            Format(GetOutlineLevel(JobTask."Job Task No.")) +
            '</OutlineLevel>');

        if HasDate then begin

            OutStream.WriteText('<Start>' +
                FormatDateTime(JobTask."Start Date") +
                '</Start>');

            OutStream.WriteText('<Finish>' +
                FormatDateTime(JobTask.EndDate) +
                '</Finish>');

            if IsMilestone then begin
                OutStream.WriteText('<Duration>PT0H0M0S</Duration>');
                OutStream.WriteText('<Milestone>1</Milestone>');
            end else begin
                OutStream.WriteText('<Duration>' +
                    GetDurationISO(JobTask) +
                    '</Duration>');
                OutStream.WriteText('<Milestone>0</Milestone>');
            end;

            OutStream.WriteText('<Summary>0</Summary>');

        end else begin

            // SUMMARY TASK
            OutStream.WriteText('<Summary>1</Summary>');
        end;

        OutStream.WriteText('<PercentComplete>0</PercentComplete>');
        OutStream.WriteText('<Manual>0</Manual>');
        OutStream.WriteText('</Task>');
    end;

    // =====================================
    // HELPER FUNCTIONS
    // =====================================

    local procedure GetOutlineLevel(TaskNo: Code[20]): Integer
    var
        DotCount: Integer;
        i: Integer;
    begin
        DotCount := 1;

        for i := 1 to StrLen(TaskNo) do
            if CopyStr(TaskNo, i, 1) = '.' then
                DotCount += 1;

        exit(DotCount);
    end;

    local procedure FormatDateTime(InputDate: Date): Text
    var
        DT: DateTime;
    begin
        DT := CreateDateTime(InputDate, 080000T);
        exit(Format(DT, 0, '<Year4>-<Month,2>-<Day,2>T08:00:00'));
    end;

    local procedure GetDurationISO(JobTask: Record "Job Task"): Text
    var
        Hours: Integer;
    begin
        // Duration diasumsikan dalam HARI
        // 1 hari = 8 jam
        Hours := JobTask.Duration * 8;
        exit('PT' + Format(Hours) + 'H0M0S');
    end;

    local procedure XmlEncode(InputText: Text): Text
    begin
        InputText := InputText.Replace('&', '&amp;');
        InputText := InputText.Replace('<', '&lt;');
        InputText := InputText.Replace('>', '&gt;');
        InputText := InputText.Replace('"', '&quot;');
        InputText := InputText.Replace('''', '&apos;');
        exit(InputText);
    end;
}
