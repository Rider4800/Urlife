codeunit 50006 postmanAPI
{
    procedure UploadFile(DocNo: Code[20]; FileNamePara: Text): Boolean
    var
        JsonVendPortObj: JsonObject;
        JsonVendPortalMsg: Text;
        //         SalesInvoiceHead: Record "Sales Invoice Header";
        //         CUBase64string: Codeunit "Base64 Convert";
        XMLInStream: InStream;
        //         PdfText: text;
        //         PdfText1: Text;
        //         StorageSetup: Record 50041;
        OutStr: OutStream;
        TempBlobCu: Codeunit "Temp Blob";
        EinvoiceHttpContent: HttpContent;
        EinvoiceHttpHeader: HttpHeaders;
        EinvoiceHttpRequest: HttpRequestMessage;
        EinvoiceHttpClient: HttpClient;
        EinvoiceHttpResponse: HttpResponseMessage;
        JResultToken: JsonToken;
        JResultObject: JsonObject;
        ResultMessage: Text;
        TextTemp1: Text;
        ErrorText: Text;
        //         // R50035: Report 50035;
        //         CompInfo: Record 79;
        Length: Integer;
        SingleByte: Byte;
    begin
        //         if SalesInvoiceHead.get(DocNo) then begin
        Clear(JsonVendPortObj);
        Clear(JsonVendPortalMsg);
        Clear(TempBlobCU);
        //             // TempBlobCU.CreateOutStream(OutStr);
        //             // if SetFilt then
        //             //     R50035.BankTypeforDigitalSign(BankType, TRUE, SalesInvoiceHead."No.")
        //             // else
        //             //     R50035.SetDocNoforDigiSig(SalesInvoiceHead."No.");
        //             // R50035.SaveAs('', ReportFormat::Pdf, OutStr);
        //             // if TempBlobCU.HasValue() then begin
        //             //     Clear(PdfText);
        //             //     Clear(XMLInStream);
        //             //     TempBlobCU.CreateInStream(XMLInStream);
        //             //     PdfText := CUBase64string.ToBase64(XMLInStream);
        //             // end;
        //             StorageSetup.Get();
        //             StorageSetup.TestField("Invoice Upload Path");
        //             JsonVendPortObj.Add('extensiontype', 'pdf');
        //             JsonVendPortObj.Add('uploadpath', StorageSetup."Invoice Upload Path");
        //             JsonVendPortObj.Add('filename', FileNamePara);
        //             JsonVendPortObj.Add('filebase64', 'data:application/pdf;base64,' + PdfText);

        //             JsonVendPortObj.WriteTo(JsonVendPortalMsg);
        Clear(EinvoiceHttpContent);
        Clear(EinvoiceHttpHeader);
        Clear(EinvoiceHttpRequest);
        Clear(EinvoiceHttpClient);
        CLEAR(TextTemp1);
        Clear(ErrorText);
        Clear(ResultMessage);
        Clear(JResultObject);
        Clear(JResultToken);
        Clear(EinvoiceHttpResponse);
        //             EinvoiceHttpContent.WriteFrom(JsonVendPortalMsg);
        //             EinvoiceHttpContent.GetHeaders(EinvoiceHttpHeader);
        //             EinvoiceHttpHeader.Clear();
        //             EinvoiceHttpHeader.Add('Content-Type', 'application/json');
        //             EinvoiceHttpRequest.Content := EinvoiceHttpContent;
        //             EinvoiceHttpRequest.SetRequestUri(StorageSetup."Digital Signature URL" + 'uploadfile');
        //             EinvoiceHttpRequest.Method := 'POST';
        //             if EinvoiceHttpClient.Send(EinvoiceHttpRequest, EinvoiceHttpResponse) then begin
        //                 EinvoiceHttpResponse.Content.ReadAs(ResultMessage);
        //                 JResultObject.ReadFrom(ResultMessage);
        //                 if JResultObject.Get('Message', JResultToken) then
        //                     if JResultToken.AsValue().AsText() = 'Uploaded Successfully !!' then begin
        //                         exit(true);
        //                     end;
        //             end else
        //                 Message('Error When Contacting API');
        //         end;
        //         exit(false);
    end;

    var
        myInt: Integer;
}