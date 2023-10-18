page 50021 "Employee Timesheet LogEntries"  //TEAM-Priyanshu
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Employee & Timesheet Log Entry";
    InsertAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("API Type"; Rec."API Type")
                {
                    ApplicationArea = All;
                }
                field(CreatedDateTime; Rec.CreatedDateTime)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job No"; Rec."Job No")
                {
                    ApplicationArea = All;
                }
                field("Job Task No"; Rec."Job Task No")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("JSON Data"; Rec."JSON Data")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Insert Timesheet Details")
            {
                ApplicationArea = All;
                Image = Timesheet;
                trigger OnAction()
                var
                    CU50015: Codeunit "Employee & Timesheet Creation";
                begin
                    //AuthenticateCredentials();
                    //InsertTimesheetDetails();
                    CU50015.Run();
                end;
            }
            action("View JSON Data")
            {
                ApplicationArea = All;
                Image = View;
                trigger OnAction()
                begin
                    Message(Rec.GetJSONData());
                end;
            }
            action("Download report")
            {
                ApplicationArea = All;
                Image = Download;
                trigger OnAction()
                var
                    TempBlob_lRec: Codeunit "Temp Blob";
                    Out: OutStream;
                    RecRef: RecordRef;
                    FileManagement_lCdu: Codeunit "File Management";
                    SalesInvoiceHeader_lRec: Record "Sales invoice Header";
                    qw: Page "Requests to Approve";
                begin
                    TempBlob_lRec.CreateOutStream(Out, TEXTENCODING::UTF8);  // Create Outstream
                    // Record filter
                    SalesInvoiceHeader_lRec.Reset;
                    SalesInvoiceHeader_lRec.SetRange("No.", '103020');
                    SalesInvoiceHeader_lRec.FindFirst();
                    RecRef.GetTable(SalesInvoiceHeader_lRec);

                    // REPORT “SAVEAS” and BLOBExport
                    REPORT.SAVEAS(1306, '', REPORTFORMAT::Pdf, Out, RecRef);    // save report in TempBlob di recRef
                    FileManagement_lCdu.BLOBExport(TempBlob_lRec, STRSUBSTNO('Proforma_%1.Pdf', SalesInvoiceHeader_lRec."No."), TRUE);   // export report in PDF format
                end;
            }
        }
    }
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

    procedure InsertTimesheetDetails()
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
        TempJobJournalLine: Record "Job Journal Line" temporary;
        JobNoVar: Code[20];
        JobTaskNoVar: Code[20];
        PostingDateVar: DateTime;
        NoVar: Code[20];
        DescVar: Text[100];
        QtyVar: Decimal;
        UOMVar: Code[10];
        Jarray: JsonArray;
        Jarray1: JsonArray;
        TotalCount: Integer;
        JobJournalLineRec: Record "Job Journal Line";
        APIRequestBody: Text;
        _LineNoVar: Integer;
        JobRec: Record Job;
        JobTaskRec: Record "Job Task";
        ServiceUnitPriceVar: Decimal;
    begin
        Http_Client.Clear();
        Http_Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', accesstoken));

        Http_Request.GetHeaders(Http_Header);
        Http_Header.Add('Accept', 'application/json');
        JResultObject.Add('Param', '01-Jan-2020 9:00:00~31-Mar-2023 9:00:00');
        JResultObject.Add('Apino', 'TMS_DATA_2487');
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
                            if JOutputObject.Get('Timesheet Data', JResultToken) then begin
                                Clear(OutputMessage);
                                JResultToken.WriteTo(OutputMessage);
                                Jarray1.ReadFrom(OutputMessage);
                                TotalCount := 0;
                                TotalCount := Jarray1.Count();

                                TempJobJournalLine.Reset();
                                TempJobJournalLine.SetRange("Journal Template Name", 'JOB');
                                TempJobJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
                                if TempJobJournalLine.FindFirst() then
                                    TempJobJournalLine.DeleteAll();

                                for i := 0 to Jarray1.Count() - 1 do begin
                                    Jarray1.Get(i, JResultToken);
                                    Clear(OutputMessage);
                                    JResultToken.WriteTo(OutputMessage);
                                    JOutputObject.ReadFrom(OutputMessage);
                                    if JOutputObject.Get('JobNo', JResultToken) then
                                        JobNoVar := CopyStr((JResultToken.AsValue().AsCode()), 1, 15);
                                    if JOutputObject.Get('JobTaskNo', JResultToken) then
                                        JobTaskNoVar := CopyStr((JResultToken.AsValue().AsCode()), 1, 15);
                                    if JOutputObject.Get('PostingDate', JResultToken) then
                                        PostingDateVar := JResultToken.AsValue().AsDateTime();
                                    if JOutputObject.Get('No', JResultToken) then
                                        NoVar := JResultToken.AsValue().AsCode();
                                    if JOutputObject.Get('Description', JResultToken) then
                                        DescVar := JResultToken.AsValue().AsText();
                                    if JOutputObject.Get('Quantity', JResultToken) then
                                        QtyVar := JResultToken.AsValue().AsDecimal();
                                    if JOutputObject.Get('UnitofMeasureCode', JResultToken) then
                                        UOMVar := JResultToken.AsValue().AsCode();

                                    TempJobJournalLine.Reset();
                                    TempJobJournalLine.Validate("Journal Template Name", 'JOB');
                                    TempJobJournalLine.Validate("Journal Batch Name", 'DEFAULT');
                                    if TempJobJournalLine.FindLast() then
                                        _LineNoVar := _LineNoVar + 1
                                    else
                                        _LineNoVar := 10000;

                                    TempJobJournalLine.Init();
                                    TempJobJournalLine.Validate("Journal Template Name", 'JOB');
                                    TempJobJournalLine.Validate("Journal Batch Name", 'DEFAULT');
                                    TempJobJournalLine."Line No." := _LineNoVar;
                                    TempJobJournalLine."Job No." := JobNoVar;
                                    TempJobJournalLine."Job Task No." := JobTaskNoVar;
                                    TempJobJournalLine.Validate("Posting Date", DT2DATE(PostingDateVar));
                                    TempJobJournalLine."No." := NoVar;
                                    TempJobJournalLine.Validate(Description, DescVar);
                                    TempJobJournalLine.Validate(Quantity, QtyVar);
                                    TempJobJournalLine."Unit of Measure Code" := UOMVar;
                                    /* if JobRec.Get(JobNoVar) then begin
                                        if JobTaskRec.Get(JobNoVar, JobTaskNoVar) then begin
                                            ServiceUnitPriceVar := 0;
                                            ServiceUnitPriceVar := JobTaskRec."Service Unit Price";
                                        end;
                                    end;
                                    JobJournalLine.Validate("Unit Price", ServiceUnitPriceVar); */
                                    TempJobJournalLine.Insert();
                                    CreateLogEntries('', '', JobNoVar, JobTaskNoVar, PostingDateVar, NoVar, DescVar, Format(QtyVar), UOMVar, 'Timesheet', OutputMessage);
                                end;
                                JobJournalLineRec.Reset();
                                JobJournalLineRec.SetRange("Journal Template Name", 'JOB');
                                JobJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                                if JobJournalLineRec.FindFirst() then
                                    JobJournalLineRec.DeleteAll();
                                //TempJobJournalLine.Reset();
                                if TempJobJournalLine.FindFirst() then begin
                                    repeat
                                        JobJournalLineRec.Init();
                                        JobJournalLineRec.TransferFields(TempJobJournalLine);
                                        JobJournalLineRec.Insert();
                                    until TempJobJournalLine.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                end;
            end else
                MESSAGE('Timesheet Insertion Failed!!');
        end;
    end;

    procedure CreateLogEntries(_EmpID: Text[20]; _EmpName: Text[100]; _JobNo: text[100]; _JobTaskNo: text[100]; _PostingDate: DateTime; _No: Text[20]; _Description: Text[50]; _Quantity: Text[10]; _UnitofMeasureCode: Text[20]; _APIType: Text[50]; _ResultMsg: Text)
    var
        EmpTimesheet_LogEntries: Record "Employee & Timesheet Log Entry";
        EmpTimesheet_LogEntriesRec: Record "Employee & Timesheet Log Entry";
        _EntryNoVar: Integer;
    begin
        if _APIType = 'Timesheet' then begin
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
            EmpTimesheet_LogEntries."Job No" := _JobNo;
            EmpTimesheet_LogEntries."Job Task No" := _JobTaskNo;
            EmpTimesheet_LogEntries."Posting Date" := _PostingDate;
            EmpTimesheet_LogEntries.No := _No;
            EmpTimesheet_LogEntries.Description := _Description;
            EmpTimesheet_LogEntries.Quantity := _Quantity;
            EmpTimesheet_LogEntries."Unit Of Measure Code" := _UnitofMeasureCode;
            EmpTimesheet_LogEntries.Insert();
            EmpTimesheet_LogEntries.SetJSONData(_ResultMsg);
        end;
    end;

    var
        accesstoken: Text;
}