codeunit 50003 "Email Process"
{
    procedure ApproveEmail(Requisition: Record "Material Req Header")
    var
        BodyText, CreateHeading : Text;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        CCEmail, BCCEmail, RecipientEmail : List of [Text];
    begin
        BodyText := 'Dear Sir/Ma''am';
        BodyText += '<br><br>';
        BodyText += 'Requisition request has been approved..';
        BodyText += '<br><br>';
        BodyText += '<br><br>';
        BodyText += '';
        BodyText += '<br><br>';
        BodyText += '<br><br>';
        BodyText += '<I>This is an electronically generated e-mail. Please do not reply on it.</I>';
        BodyText += '<br><br>';
        BodyText += '<br><br>';
        BodyText += 'Thank You!';
        BodyText += '<br><br>';
        BodyText += '<br><br>';

        CCEmail.Add('shashank.pathak@teamcomputers.com');
        EmailMsg.Create(RecipientEmail, CreateHeading, BodyText, true, CCEmail, BCCEmail);
        EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
    end;
}