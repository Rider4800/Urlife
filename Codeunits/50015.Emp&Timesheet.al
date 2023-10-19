codeunit 50015 "Employee & Timesheet Creation"  //TEAM-Priyanshu
{
    var
        accesstoken: Text;
        JobSetupRec: Record "Jobs Setup";
        JobQueueLogEntryRec: Record "Job Queue Log Entry";

    trigger OnRun()
    begin
        AuthenticateCredentials();
        InsertEmployeeDetails();
    end;

    procedure AuthenticateCredentials()
    var
        _HttpClient: HttpClient;
        _HttpRequest: HttpRequestMessage;
        _HttpContent: HttpContent;
        _HttpHeader: HttpHeaders;
        _HttpResponse: HttpResponseMessage;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        ResultMessage: Text;
        TokenRequestbody: Text;
    begin
        TokenRequestbody := 'Username=APPLIFEUAT&Password=2930EB7F&grant_type=password';
        _HttpContent.WriteFrom(TokenRequestbody);
        _HttpContent.GetHeaders(_HttpHeader);
        _HttpHeader.Clear();
        _HttpHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        _HttpHeader.Add('Return-Type', 'application/text');
        _HttpRequest.Content := _HttpContent;
        _HttpRequest.SetRequestUri('https://hrms.myadrenalin.com/cloudapi/Adrenalintoken');
        _HttpRequest.Method := 'POST';
        if _HttpClient.Send(_HttpRequest, _HttpResponse) then begin
            _HttpResponse.Content.ReadAs(ResultMessage);
            JResultObject.ReadFrom(ResultMessage);

            if JResultObject.Get('access_token', JResultToken) then
                accesstoken := JResultToken.AsValue().AsText();
            Message(accesstoken);
        end else
            Message('Authentication Failed');
    end;

    procedure InsertEmployeeDetails()
    var
        Http_Content: HttpContent;
        Http_Header: HttpHeaders;
        Content_Header: HttpHeaders;
        Http_Request: HttpRequestMessage;
        Http_Client: HttpClient;
        Http_Response: HttpResponseMessage;
        JOutputObject: JsonObject;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        OutputMessage: Text;
        ResultMessage: Text;
        MessageVar: Text;
        i: Integer;
        Employee: Record Employee;
        EmployeeIDVar: Code[20];
        EmployeeNameVar: Text;
        Jarray: JsonArray;
        Jarray1: JsonArray;
        TotalCount: Integer;
        EmployeeRec: Record Employee;
        APIRequestBody: Text;
        FinalDatetimeVar: Text[200];
        ToDateVar: Text[10];
        ToMonthVar: Text[20];
        ToYearVar: Text[10];
        ToTimeVar: Text[10];
    begin
        ToDateVar := Format(Date2DMY(DT2Date(CurrentDateTime), 1));
        ToMonthVar := Format(DT2Date(CurrentDateTime), 0, '<Month Text,3>');
        ToYearVar := Format(Date2DMY(DT2Date(CurrentDateTime), 3));
        ToTimeVar := Format(DT2Time(CurrentDateTime));
        JobSetupRec.Reset();
        JobSetupRec.SetFilter("Last Run Date & Time", '<>%1', '');
        if JobSetupRec.FindFirst() then
            FinalDatetimeVar := JobSetupRec."Last Run Date & Time" + '~' + ToDateVar + '-' + ToMonthVar + '-' + ToYearVar + ' ' + ToTimeVar;
        Http_Client.Clear();
        Http_Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', accesstoken));
        Http_Request.GetHeaders(Http_Header);
        Http_Header.Add('Accept', 'application/json');
        JResultObject.Add('Param', FinalDatetimeVar);
        //JResultObject.Add('Param', '01-Jan-2023 9:00:00~31-Mar-2023 9:00:00');
        JResultObject.Add('Apino', 'EMP_LOCDET_2487');
        JResultObject.WriteTo(APIRequestBody);
        APIRequestBody := '[' + APIRequestBody + ']';
        Http_Content.WriteFrom(APIRequestBody);
        Http_Request.Content := Http_Content;
        Http_Request.Content.GetHeaders(Content_Header);
        Content_Header.Remove('Content-Type');
        Content_Header.Add('Content-Type', 'application/json');
        Http_Request.SetRequestUri('https://hrms.myadrenalin.com/cloudapi/HRdata/Getdata');
        Http_Request.Method := 'POST';

        if Http_Client.Send(Http_Request, Http_Response) then begin
            Http_Response.Content.ReadAs(ResultMessage);
            Jarray.ReadFrom(ResultMessage);
            Message(Format(ResultMessage));

            if Jarray.Get(0, JResultToken) then begin
                JResultToken.WriteTo(OutputMessage);
                JOutputObject.ReadFrom(OutputMessage);
                IF JOutputObject.Get('Message', JResultToken) then begin
                    MessageVar := JResultToken.AsValue().AsText();
                    If MessageVar = 'Success' then begin
                        if JOutputObject.Get('Data', JResultToken) then begin
                            Clear(OutputMessage);
                            JResultToken.WriteTo(OutputMessage);
                            JOutputObject.ReadFrom(OutputMessage);
                            if JOutputObject.Get('EMPLOYEE LOC DETAILS', JResultToken) then begin
                                Clear(OutputMessage);
                                JResultToken.WriteTo(OutputMessage);
                                Jarray1.ReadFrom(OutputMessage);
                                TotalCount := 0;
                                TotalCount := Jarray1.Count();

                                for i := 0 to Jarray1.Count() - 1 do begin
                                    Jarray1.Get(i, JResultToken);
                                    Clear(OutputMessage);
                                    JResultToken.WriteTo(OutputMessage);
                                    JOutputObject.ReadFrom(OutputMessage);
                                    if JOutputObject.Get('Employee ID', JResultToken) then
                                        EmployeeIDVar := JResultToken.AsValue().AsCode();
                                    if JOutputObject.Get('Employee Name', JResultToken) then
                                        EmployeeNameVar := JResultToken.AsValue().AsCode();

                                    if EmployeeRec.Get(EmployeeIDVar) then begin
                                        EmployeeRec."Search Name" := EmployeeNameVar;
                                        EmployeeRec.Modify();
                                    end else begin
                                        Employee.Init();
                                        Employee."No." := EmployeeIDVar;
                                        Employee."Search Name" := EmployeeNameVar;
                                        Employee.Insert();
                                    end;
                                    CreateLogEntries(EmployeeIDVar, EmployeeNameVar, '', '', 0DT, '', '', '', '', 'Employee', OutputMessage);
                                end;
                                JobSetupRec."Last Run Date & Time" := Format(Date2DMY(DT2Date(CurrentDateTime), 1)) + '-' + Format(DT2Date(CurrentDateTime), 0, '<Month Text,3>') + '-' + Format(Date2DMY(DT2Date(CurrentDateTime), 3)) + ' ' + Format(DT2Time(CurrentDateTime));
                                JobSetupRec.Modify();
                            end;
                        end;
                    end;
                end;
            end else
                MESSAGE('Employee Insertion Failed!!');
        end;
    end;

    procedure CreateLogEntries(_EmpID: Text[20]; _EmpName: Text[100]; _JobNo: text[100]; _JobTaskNo: text[100]; _PostingDate: DateTime; _No: Text[20]; _Description: Text[50]; _Quantity: Text[10]; _UnitofMeasureCode: Text[20]; _APIType: Text[50]; _ResultMsg: Text)
    var
        EmpTimesheet_LogEntries: Record "Employee & Timesheet Log Entry";
        EmpTimesheet_LogEntriesRec: Record "Employee & Timesheet Log Entry";
        _EntryNoVar: Integer;
    begin
        if _APIType = 'Employee' then begin
            EmpTimesheet_LogEntriesRec.Reset();
            if EmpTimesheet_LogEntriesRec.FindLast() then
                _EntryNoVar := EmpTimesheet_LogEntriesRec."Entry No" + 1
            else
                _EntryNoVar := 1;
            EmpTimesheet_LogEntries.Init();
            EmpTimesheet_LogEntries."Entry No" := _EntryNoVar;
            EmpTimesheet_LogEntries."API Type" := _APIType;
            EmpTimesheet_LogEntries.CreatedDateTime := CurrentDateTime;
            EmpTimesheet_LogEntries."Created By" := UserId;
            EmpTimesheet_LogEntries."Employee ID" := _EmpID;
            EmpTimesheet_LogEntries."Employee Name" := _EmpName;
            EmpTimesheet_LogEntries.Insert();
            EmpTimesheet_LogEntries.SetJSONData(_ResultMsg);
        end;
    end;
}