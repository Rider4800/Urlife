codeunit 50002 "Get Timesheet"
{
    trigger OnRun()
    var
        RecSalesRecSetup: Record "Sales & Receivables Setup";
        JSONObj, JResultObject : JsonObject;
        Http_Content: HttpContent;
        Http_Header: HttpHeaders;
        Http_Request: HttpRequestMessage;
        Http_Client: HttpClient;
        Http_Response: HttpResponseMessage;
        JResultToken, JResultToken1 : JsonToken;
        ResultMessage: Text;
    begin
        RecSalesRecSetup.Get;
        RecSalesRecSetup.TestField("Adrenalin API URL");

        DateText := FORMAT(DATE2DMY(TODAY, 3)) + checkPreNumber(FORMAT(DATE2DMY(TODAY, 2))) + checkPreNumber(FORMAT(DATE2DMY(TODAY, 1)));
        //DateText := '20210125';
        PostUrl := 'http://hrms.apollolife.com/AdrenalinWEBAPI/APPLIFE/12345/DT_668/TMS_DATA_2487/' + DateText + '?type=json';

        //Http_Content.WriteFrom(Format(JSONObj));
        Http_Header.Clear();
        Http_Content.GetHeaders(Http_Header);
        Http_Header.Remove('Content-Type');
        Http_Header.Add('Content-Type', 'application/json');
        Http_Request.Content := Http_Content;
        Http_Request.SetRequestUri(PostUrl);
        Http_Request.Method('GET');

        if Http_Client.Send(Http_Request, Http_Response) then begin
            Http_Response.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);


        end;


        /*
        HttpWebRequestMgt.Initialize(PostUrl);
        HttpWebRequestMgt.DisableUI;
        HttpWebRequestMgt.SetMethod('GET');
        HttpWebRequestMgt.SetReturnType('application/json');
        TempBlob.INIT;
        TempBlob.Blob.CREATEINSTREAM(InStr);
        IF HttpWebRequestMgt.GetResponse(InStr, HTTPStatusCode, ResponseHeaders) THEN BEGIN
            TempBig.ADDTEXT('{"Data":', 1);
            TempBig.ADDTEXT(TempBlob.ReadAsText('', TEXTENCODING::UTF8), 10);
            TempBig.ADDTEXT('}', STRLEN(TempBlob.ReadAsText('', TEXTENCODING::UTF8)) + 10);
            //MESSAGE(FORMAT(TempBig));
            JObject := JObject.Parse(TempBig);
            JObject := JObject.GetValue('Data');
            FOR i := 1 TO JObject.Count DO BEGIN
                IF i = 1 THEN
                    JObject := JObject.First;
                EVALUATE(PostDate, FORMAT(JObject.GetValue('PostingDate')));
                LineNo += 10000;
                CLEAR(JobJournalLine);
                CLEAR(JobJournalBatch);
                CLEAR(DocNo);
                JobJournalBatch.GET('JOB', 'DEFAULT');
                DocNo := NoSeriesManagement.GetNextNo(JobJournalBatch."No. Series", TODAY, FALSE);
                JobJournalLine.INIT;
                JobJournalLine.VALIDATE("Journal Template Name", 'JOB');
                JobJournalLine.VALIDATE("Journal Batch Name", 'DEFAULT');
                JobJournalLine.VALIDATE("Document No.", DocNo);
                JobJournalLine.VALIDATE("Location Code", 'DELHI');
                JobJournalLine."Line No." := LineNo;
                JobJournalLine.VALIDATE("Posting Date", DT2DATE(PostDate));
                JobJournalLine.VALIDATE("Job No.", FORMAT(JObject.GetValue('JobNo')));
                JobJournalLine.VALIDATE("Job Task No.", FORMAT(JObject.GetValue('JobTaskNo')));
                JobJournalLine.VALIDATE("No.", FORMAT(JObject.GetValue('No')));
                JobJournalLine.Description := FORMAT(JObject.GetValue('Description'));
                EVALUATE(JobJournalLine.Quantity, FORMAT(JObject.GetValue('Quantity')));
                JobJournalLine.VALIDATE("Posting No. Series", JobJournalBatch."Posting No. Series");
                JobJournalLine.VALIDATE("Unit of Measure Code", FORMAT(JObject.GetValue('UnitofMeasureCode')));
                JobJournalLine.INSERT(TRUE);
                CreateJobPlanningLine(JobJournalLine);
                JObject := JObject.Next;
            END;
            MESSAGE('Timesheet Data is created in Navision for Today,Please check on Approved Timesheet page.');
        END;
        */
    end;

    var
        //TEAM 14763 JSONStr: DotNet String;
        Url: Text;
        //TEAM 14763 HttpWebRequestMgt: Codeunit "1297";
        //TEAM 14763 TempBlob: Record "99008535";
        InStr: InStream;
        //TEAM 14763 HTTPStatusCode: DotNet HttpStatusCode;
        //TEAM 14763 ResponseHeaders: DotNet NameObjectCollectionBase;
        //TEAM 14763 JObject: DotNet JObject;
        //TEAM 14763 JSONResponse: DotNet String;
        ErrorMessage: Text;
        ErrorText: Text;
        isSuccess: Text;
        TextTemp1: Text;
        //TEAM 14763 JSONManagement: Codeunit "5459";
        ArrayString: Text;
        PostUrl: Text;
        DateText: Text;
        TempBig: BigText;
        i: Integer;
        JobJournalLine: Record "Job Journal Line";
        LineNo: Integer;
        PostDate: DateTime;
        JobJournalBatch: Record "Job Journal Batch";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocNo: Code[20];

    local procedure checkPreNumber(DateSTR: Text): Text
    begin
        IF STRLEN(DateSTR) = 1 THEN
            EXIT('0' + DateSTR)
        ELSE
            EXIT(DateSTR);
    end;

    local procedure CreateJobPlanningLine(JobJournalLine: Record "Job Journal Line")
    var
        JobPlanningLine: Record "Job Planning Line";
        LineNo: Integer;
    begin
        JobPlanningLine.RESET;
        JobPlanningLine.SETRANGE("Job No.", JobJournalLine."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobJournalLine."Job Task No.");
        IF JobPlanningLine.FINDLAST THEN
            LineNo := JobPlanningLine."Line No." + 10000
        ELSE
            LineNo := 10000;

        JobPlanningLine.SETRANGE(Type, JobPlanningLine.Type::Resource);
        JobPlanningLine.SETRANGE("No.", JobJournalLine."No.");
        IF JobPlanningLine.FINDFIRST THEN BEGIN
            JobPlanningLine."Planning Date" := JobJournalLine."Posting Date";
            JobPlanningLine.VALIDATE(Quantity, JobPlanningLine.Quantity + JobJournalLine.Quantity);
            JobPlanningLine.MODIFY(TRUE);
        END ELSE BEGIN
            JobPlanningLine.INIT;
            JobPlanningLine.VALIDATE("Job No.", JobJournalLine."Job No.");
            JobPlanningLine.VALIDATE("Job Task No.", JobJournalLine."Job Task No.");
            JobPlanningLine.VALIDATE("Line No.", LineNo);
            //TEAM 14763 JobPlanningLine.VALIDATE("Line Type", JobPlanningLine."Line Type"::Contract);
            JobPlanningLine.VALIDATE("Planning Date", JobJournalLine."Posting Date");
            JobPlanningLine.VALIDATE(Type, JobPlanningLine.Type::Resource);
            JobPlanningLine.VALIDATE("No.", JobJournalLine."No.");
            JobPlanningLine.VALIDATE("Location Code", 'DELHI');
            JobPlanningLine.VALIDATE(Quantity, JobJournalLine.Quantity);
            JobPlanningLine.INSERT(TRUE);
        END;
    end;
}