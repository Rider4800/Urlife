codeunit 50001 "Darwin API"
{
    procedure GetJobDetails(var Job: XMLport 50004; var Status: Boolean; var Message: Text; CreatedOn: Date)
    var
        JobL: Record 167;
    begin
        CLEARLASTERROR;
        JobL.RESET;
        JobL.SETRANGE("Modified Date", CreatedOn);
        Job.SETTABLEVIEW(JobL);
        IF JobL.COUNT <> 0 THEN BEGIN
            IF Job.EXPORT THEN BEGIN
                Status := TRUE;
                Message := 'Successsful';
            END ELSE BEGIN
                Status := FALSE;
                Message := GETLASTERRORTEXT;
            END
        END ELSE
            Message := 'No data ia available';
    end;

    procedure GetJobTask(var JobTask: XMLport 50003; var Status: Boolean; var Message: Text; CreatedOn: Date)
    var
        JobTaskRec: Record 1001;
        Job: Record 167;
    begin
        CLEARLASTERROR;
        JobTaskRec.RESET;
        //JobTaskRec.SETRANGE("Job No.",JobNo);
        JobTaskRec.SETRANGE("Modified Date", CreatedOn);
        JobTask.SETTABLEVIEW(JobTaskRec);
        //IF Job.GET(JobNo) THEN BEGIN
        IF JobTaskRec.COUNT <> 0 THEN BEGIN
            IF JobTask.EXPORT THEN BEGIN
                Status := TRUE;
                Message := 'Successsful';
            END ELSE BEGIN
                Status := FALSE;
                Message := GETLASTERRORTEXT;
            END
        END ELSE
            Message := 'No data ia available';
        // END ELSE
        // Message := 'Job '+JobNo+' not exists in Nav system.';
    end;
}

