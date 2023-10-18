codeunit 50005 "Expiring Contract Notification"
{
    trigger OnRun()
    begin
        SalesPersonWise;
        CustomerWise;
    end;

    var
        Job: Record 167;
        EndDateVar: Date;
        //TEAM 14763  SMTPMail: Codeunit 400;
        //TEAM 14763 SMTPMailSetup: Record 409;
        CompInfo: Record 79;
        Text001: Label 'Alert for Contract going to expire next week - %1.';
        BilltoCustNo: Code[20];
        JobRec1: Record 167;
        SalesHeader: Record 36;
        MachineJobLine: Record 50000;
        Activity: Text;
        i: Integer;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCheckPostingGroupChange', '', false, false)]
    local procedure OnBeforeCheckPostingGroupChange(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PostingGroupChangeInterface: Interface "Posting Group Change Method";
        RecEmp: Record Employee;
        VarHumanSetup: Record "Human Resources Setup";
    // IsHandled: Boolean;
    begin
        IsHandled := true;
        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::Employee:
                begin
                    RecEmp.Get(GenJournalLine."Account No.");
                    VarHumanSetup.Get();
                    if VarHumanSetup."Allow Multiple Posting" then begin
                        VarHumanSetup.TestField("Allow Multiple Posting");
                        PostingGroupChangeInterface := VarHumanSetup."Check Multiple Posting Groups";
                        // PostingGroupChangeInterface.ChangePostingGroup(GenJournalLine."Posting Group", xGenJournalLine."Posting Group", GenJournalLine);
                    end;
                end;
        end;
    end;
    ///Event Subscriber rlated to creation of new record in the table G/L Account.
    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnAfterSetupNewGLAcc', '', false, false)]
    local procedure OnAfterSetupNewGLAcc(var GLAccount: Record "G/L Account")
    var
        RecUserSetup: Record "User Setup";
    begin
        RecUserSetup.Reset();
        RecUserSetup.SetRange("User ID", UserId);
        RecUserSetup.SetRange("Permission Modify Create", true);
        if not RecUserSetup.FindFirst() then
            Error('You do not have permission to create new record.');
    end;

    // [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnAfterSetupNewGLAcc', '', false, false)]




    local procedure SalesPersonWise()
    var
        BodyText: Text;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        CCEmail, BCCEmail, RecepientEmail : List of [Text];
    begin
        Job.RESET;
        Job.SETFILTER("Ending Date", '<>%1', 0D);
        IF Job.FINDFIRST THEN BEGIN
            REPEAT
                CLEAR(EndDateVar);
                EndDateVar := CALCDATE('<-7D>', Job."Ending Date");
                IF EndDateVar = TODAY THEN BEGIN
                    MachineJobLine.RESET;
                    MachineJobLine.SETRANGE("Job Document No", Job."No.");
                    MachineJobLine.CALCSUMS(Amount);
                    IF MachineJobLine.FINDFIRST THEN BEGIN
                        IF SalesHeader.GET(SalesHeader."Document Type"::Quote, MachineJobLine."Sales Quote No.") THEN;
                        IF SalesHeader."Salesperson Code" <> BilltoCustNo THEN BEGIN
                            i := 1;
                            REPEAT
                                IF i = 1 THEN
                                    Activity := MachineJobLine."Activity Description"
                                ELSE
                                    Activity += ',' + MachineJobLine."Activity Description";
                                i += 1;
                            UNTIL MachineJobLine.NEXT = 0;

                            BodyText := ' Sir/Mam,';

                            BodyText += 'Sir/Mam,';
                            BodyText += '<br><br>';
                            BodyText += 'Greetings of the day';
                            BodyText += '<br><br><br>';
                            BodyText += 'Details of contracts expiring in next week-<br><br>';
                            BodyText += '<TABLE border = "2">';
                            BodyText += '<TH>Project Code</TH>';
                            BodyText += '<TH>Project Description</TH>';
                            BodyText += '<TH>Total Bill</TH>';
                            //BodyText += '<TH>Project Scope</TH>';
                            BodyText += '<TH>Project Start Date</TH>';
                            BodyText += '<TH>Project End Date</TH>';


                            JobRec1.RESET;
                            JobRec1.SETFILTER("Ending Date", '<>%1', 0D);
                            JobRec1.SETRANGE("Bill-to Customer No.", Job."Bill-to Customer No.");
                            IF JobRec1.FINDFIRST THEN BEGIN
                                REPEAT
                                    CLEAR(EndDateVar);
                                    EndDateVar := CALCDATE('<-7D>', JobRec1."Ending Date");
                                    IF EndDateVar = TODAY THEN BEGIN
                                        BodyText += '<TR>';
                                        BodyText += '<TD>' + JobRec1."No." + '</TD>';
                                        BodyText += '<TD>' + JobRec1.Description + '</TD>';
                                        BodyText += '<TD>' + FORMAT(MachineJobLine.Amount) + '</TD>';
                                        //SMTPMail.AppendBody('<TD>'+Activity+'</TD>');
                                        BodyText += '<TD>' + FORMAT(JobRec1."Starting Date") + '</TD>';
                                        BodyText += '<TD>' + FORMAT(JobRec1."Ending Date") + '</TD>';
                                    END;
                                UNTIL JobRec1.NEXT = 0;
                            END;

                            BodyText += '</TABLE>';
                            BodyText += '<br><br><br>';
                            BodyText += '<B>' + 'Regards' + '</B>';
                            BodyText += '<br>';
                            CompInfo.GET;
                            BodyText += '<B>' + CompInfo.Name + '</B>';
                            BodyText += '<br><br><br><br><br>';
                            BodyText += '<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>';
                            BilltoCustNo := SalesHeader."Salesperson Code";

                            RecepientEmail.Add('shivshant.gupta@teamcomputers.com');
                            CCEmail.Add('vivek.rawat@teamcomputers.com');
                            BCCEmail.Add('shashank.pathak@teamcomputers.com');

                            EmailMsg.Create(RecepientEmail, STRSUBSTNO(Text001, Job."Bill-to Name"), BodyText, true, CCEmail, BCCEmail);
                            EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);

                            /*
                            SMTPMailSetup.GET;
                            SMTPMail.CreateMessage('', SMTPMailSetup."User ID", 'shivshant.gupta@teamcomputers.com', STRSUBSTNO(Text001, Job."Bill-to Name"), '', TRUE);
                            SMTPMail.AddCC('vivek.rawat@teamcomputers.com');
                            SMTPMail.AppendBody('Sir/Mam,');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Greetings of the day');
                            SMTPMail.AppendBody('<br><br><br>');
                            SMTPMail.AppendBody('Details of contracts expiring in next week-<br><br>');
                            SMTPMail.AppendBody('<TABLE border = "2">');
                            SMTPMail.AppendBody('<TH>Project Code</TH>');
                            SMTPMail.AppendBody('<TH>Project Description</TH>');
                            SMTPMail.AppendBody('<TH>Total Bill</TH>');
                            //SMTPMail.AppendBody('<TH>Project Scope</TH>');
                            SMTPMail.AppendBody('<TH>Project Start Date</TH>');
                            SMTPMail.AppendBody('<TH>Project End Date</TH>');

                            JobRec1.RESET;
                            JobRec1.SETFILTER("Ending Date", '<>%1', 0D);
                            JobRec1.SETRANGE("Bill-to Customer No.", Job."Bill-to Customer No.");
                            IF JobRec1.FINDFIRST THEN BEGIN
                                REPEAT
                                    CLEAR(EndDateVar);
                                    EndDateVar := CALCDATE('<-7D>', JobRec1."Ending Date");
                                    IF EndDateVar = TODAY THEN BEGIN
                                        SMTPMail.AppendBody('<TR>');
                                        SMTPMail.AppendBody('<TD>' + JobRec1."No." + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + JobRec1.Description + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + FORMAT(MachineJobLine.Amount) + '</TD>');
                                        //SMTPMail.AppendBody('<TD>'+Activity+'</TD>');
                                        SMTPMail.AppendBody('<TD>' + FORMAT(JobRec1."Starting Date") + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + FORMAT(JobRec1."Ending Date") + '</TD>');
                                    END;
                                UNTIL JobRec1.NEXT = 0;
                            END;
                            SMTPMail.AppendBody('</TABLE>');
                            SMTPMail.AppendBody('<br><br><br>');
                            SMTPMail.AppendBody('<B>' + 'Regards' + '</B>');
                            SMTPMail.AppendBody('<br>');
                            CompInfo.GET;
                            SMTPMail.AppendBody('<B>' + CompInfo.Name + '</B>');
                            SMTPMail.AppendBody('<br><br><br><br><br>');
                            SMTPMail.AppendBody('<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>');
                            BilltoCustNo := SalesHeader."Salesperson Code";
                            SMTPMail.Send;
                            */
                        END;
                    END;
                END;
            UNTIL Job.NEXT = 0;
        END;
    end;

    local procedure CustomerWise()
    begin
        Job.RESET;
        Job.SETFILTER("Ending Date", '<>%1', 0D);
        IF Job.FINDFIRST THEN BEGIN
            REPEAT
                CLEAR(EndDateVar);
                EndDateVar := CALCDATE('<-7D>', Job."Ending Date");
                IF EndDateVar = TODAY THEN BEGIN
                    IF Job."Bill-to Customer No." <> BilltoCustNo THEN BEGIN
                        /*
                            SMTPMailSetup.GET;
                            SMTPMail.CreateMessage('', SMTPMailSetup."User ID", 'shivshant.gupta@teamcomputers.com', STRSUBSTNO(Text001, Job."Bill-to Name"), '', TRUE);
                            SMTPMail.AddCC('vivek.rawat@teamcomputers.com');
                            SMTPMail.AppendBody('Sir/Mam,');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Greetings of the day');
                            SMTPMail.AppendBody('<br><br><br>');
                            SMTPMail.AppendBody('Details of contracts expiring in next week-<br><br>');
                            SMTPMail.AppendBody('<TABLE border = "2">');
                            SMTPMail.AppendBody('<TH>Project Code</TH>');
                            SMTPMail.AppendBody('<TH>Project Description</TH>');
                            SMTPMail.AppendBody('<TH>Project Start Date</TH>');
                            SMTPMail.AppendBody('<TH>Project End Date</TH>');
                            JobRec1.RESET;
                            JobRec1.SETFILTER("Ending Date", '<>%1', 0D);
                            JobRec1.SETRANGE("Bill-to Customer No.", Job."Bill-to Customer No.");
                            IF JobRec1.FINDFIRST THEN BEGIN
                                REPEAT
                                    CLEAR(EndDateVar);
                                    EndDateVar := CALCDATE('<-7D>', JobRec1."Ending Date");
                                    IF EndDateVar = TODAY THEN BEGIN
                                        SMTPMail.AppendBody('<TR>');
                                        SMTPMail.AppendBody('<TD>' + JobRec1."No." + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + JobRec1.Description + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + FORMAT(JobRec1."Starting Date") + '</TD>');
                                        SMTPMail.AppendBody('<TD>' + FORMAT(JobRec1."Ending Date") + '</TD>');
                                    END;
                                UNTIL JobRec1.NEXT = 0;
                            END;
                            SMTPMail.AppendBody('</TABLE>');
                            SMTPMail.AppendBody('<br><br><br>');
                            SMTPMail.AppendBody('<B>' + 'Regards' + '</B>');
                            SMTPMail.AppendBody('<br>');
                            CompInfo.GET;
                            SMTPMail.AppendBody('<B>' + CompInfo.Name + '</B>');
                            SMTPMail.AppendBody('<br><br><br><br><br>');
                            SMTPMail.AppendBody('<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>');
                            BilltoCustNo := JobRec1."Bill-to Customer No.";
                            SMTPMail.Send;
                            */
                    END;
                END;
            UNTIL Job.NEXT = 0;
        END;
    end;
}

