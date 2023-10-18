codeunit 50004 "Cust Leg Due Date Mail"
{
    trigger OnRun()
    var
        BodyText: Text;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        CCEmail, BCCEmail, RecepientEmail : List of [Text];
    begin
        RecCust.RESET;
        //RecCust.SETFILTER("No.",'<>%1','');
        //RecCust.SETFILTER("No.",'%1','C00010');
        RecCust.SETRANGE("Send Alert For Due Date", TRUE);
        IF RecCust.FINDSET THEN BEGIN
            REPEAT
                Clear(EmailMsg);
                BodyText := 'Sir/Mam,';
                BodyText += '<br><br>';
                BodyText += 'Greetings of the day';
                BodyText += '<br><br><br>';
                BodyText += 'The Due Date has been passed.<br><br>';
                BodyText += '<TABLE border = "2">';
                BodyText += '<TH>Invoice No</TH>';
                BodyText += '<TH>Due Date</TH>';
                BodyText += '<TH>Invoice Amount</TH>';
                BodyText += '<TH>Remaining Amount</TH>';

                CustLedEnt.RESET;
                CustLedEnt.SETAUTOCALCFIELDS(Amount, "Remaining Amount");
                CustLedEnt.SETCURRENTKEY("Customer No.");
                CustLedEnt.SETRANGE("Document Type", CustLedEnt."Document Type"::Invoice);
                CustLedEnt.SETRANGE("Customer No.", RecCust."No.");
                CustLedEnt.SETFILTER("Remaining Amount", '<>%1', 0);
                CustLedEnt.SETFILTER("Due Date", '<=%1', TODAY);   //TODAY    301221D
                IF CustLedEnt.FINDSET THEN
                    REPEAT
                        CustNo := CustLedEnt."Customer No.";
                        BodyText += '<TR>';
                        BodyText += '<TD>' + CustLedEnt."Document No." + '</TD>';
                        BodyText += '<TD>' + FORMAT(CustLedEnt."Due Date") + '</TD>';
                        BodyText += '<TD ALIGN = RIGHT>' + FORMAT(CustLedEnt.Amount) + '</TD>';
                        BodyText += '<TD ALIGN = RIGHT>' + FORMAT(CustLedEnt."Remaining Amount") + '</TD>';
                    UNTIL CustLedEnt.NEXT = 0;

                BodyText += '</TABLE>';
                BodyText += '<br><br><br>';
                BodyText += '<B>' + 'Regards' + '</B>';
                BodyText += '<br>';
                CompInfo.GET;
                BodyText += '<B>' + CompInfo.Name + '</B>';
                BodyText += '<br><br><br><br><br>';
                BodyText += '<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>';

                IF CustNo <> '' THEN begin
                    RecepientEmail.Add('shivshant.gupta@teamcomputers.com');

                    CCEmail.Add('shashank.pathak@teamcomputers.com');
                    BCCEmail.Add('shashank.pathak@teamcomputers.com');

                    EmailMsg.Create(RecepientEmail, STRSUBSTNO(Text002, RecCust.Name), BodyText, true, CCEmail, BCCEmail);
                    EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
                end;


            /*
                CLEAR(CustNo);
                SMTPMailSetup.GET;
                SMTPMail.CreateMessage('', SMTPMailSetup."User ID", 'shivshant.gupta@teamcomputers.com', STRSUBSTNO(Text002, RecCust.Name), '', TRUE);
                SMTPMail.AppendBody('Sir/Mam,');
                SMTPMail.AppendBody('<br><br>');
                SMTPMail.AppendBody('Greetings of the day');
                SMTPMail.AppendBody('<br><br><br>');
                SMTPMail.AppendBody('The Due Date has been passed.<br><br>');
                SMTPMail.AppendBody('<TABLE border = "2">');
                SMTPMail.AppendBody('<TH>Invoice No</TH>');
                SMTPMail.AppendBody('<TH>Due Date</TH>');
                SMTPMail.AppendBody('<TH>Invoice Amount</TH>');
                SMTPMail.AppendBody('<TH>Remaining Amount</TH>');

                CustLedEnt.RESET;
                CustLedEnt.SETAUTOCALCFIELDS(Amount, "Remaining Amount");
                CustLedEnt.SETCURRENTKEY("Customer No.");
                CustLedEnt.SETRANGE("Document Type", CustLedEnt."Document Type"::Invoice);
                CustLedEnt.SETRANGE("Customer No.", RecCust."No.");
                CustLedEnt.SETFILTER("Remaining Amount", '<>%1', 0);
                CustLedEnt.SETFILTER("Due Date", '<=%1', TODAY);   //TODAY    301221D
                IF CustLedEnt.FINDSET THEN
                    REPEAT
                        CustNo := CustLedEnt."Customer No.";

                        SMTPMail.AppendBody('<TR>');
                        SMTPMail.AppendBody('<TD>' + CustLedEnt."Document No." + '</TD>');
                        SMTPMail.AppendBody('<TD>' + FORMAT(CustLedEnt."Due Date") + '</TD>');
                        SMTPMail.AppendBody('<TD ALIGN = RIGHT>' + FORMAT(CustLedEnt.Amount) + '</TD>');
                        SMTPMail.AppendBody('<TD ALIGN = RIGHT>' + FORMAT(CustLedEnt."Remaining Amount") + '</TD>');

                    UNTIL CustLedEnt.NEXT = 0;
                SMTPMail.AppendBody('</TABLE>');
                SMTPMail.AppendBody('<br><br><br>');
                SMTPMail.AppendBody('<B>' + 'Regards' + '</B>');
                SMTPMail.AppendBody('<br>');
                CompInfo.GET;
                SMTPMail.AppendBody('<B>' + CompInfo.Name + '</B>');
                SMTPMail.AppendBody('<br><br><br><br><br>');
                SMTPMail.AppendBody('<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>');
                IF CustNo <> '' THEN BEGIN
                    SMTPMail.Send;
                END;
                */
            UNTIL RecCust.NEXT = 0;
            MESSAGE('Mail Sent');
        END;
    end;

    var
        RecCust: Record Customer;
        CustLedEnt: Record "Cust. Ledger Entry";
        CustNo: Code[20];
        //SMTPMailSetup: Record "409";
        //SMTPMail: Codeunit "400";
        Text001: Label 'Alert for Candidate Requisition for Project - %1.';
        CompInfo: Record "Company Information";
        MachineJobLine: Record "Machine Job Line";
        Text002: Label 'Payment Due Alert for - %1.';

    local procedure MailBodytoCust(RecCustLedEnt: Record "Cust. Ledger Entry")
    var
    //SMTPMailSetup: Record "409";
    //SMTPMail: Codeunit "400";
    begin
    end;

    procedure SendCandidateRequisition(Job: Record Job)
    var
        BodyText: Text;
        EmailMsg: Codeunit "Email Message";
        EmailObj: Codeunit Email;
        CCEmail, BCCEmail, RecepientEmail : List of [Text];
        JobTask: Record "Job Task";
    begin

        BodyText := 'Sir/Mam,';
        BodyText += '<br><br>';
        BodyText += 'Greetings of the day';
        BodyText += '<br><br><br>';
        BodyText += 'Candidate Requisition Details-<br><br>';
        BodyText += '<TABLE border = "2">';
        BodyText += '<TH>Project Name</TH>';
        BodyText += '<TH>Job Type</TH>';
        BodyText += '<TH>Project Start Date</TH>';
        BodyText += '<TH>Project End Date</TH>';
        BodyText += '<TH>People Count Needed</TH>';

        JobTask.RESET;
        JobTask.SETRANGE("Job Task No.", Job."No.");
        //MachineJobLine.SETFILTER("Hring Candidate No",'<>%1',0);
        IF JobTask.FINDSET THEN
            REPEAT
                BodyText += '<TR>';
                //SMTPMail.AppendBody('<TD>'+Job."No."+'</TD>');
                BodyText += '<TD>' + Job.Description + '</TD>';
                BodyText += '<TD>' + MachineJobLine."Activity Code" + '</TD>';
                BodyText += '<TD>' + FORMAT(Job."Starting Date") + '</TD>';
                BodyText += '<TD>' + FORMAT(Job."Ending Date") + '</TD>';
                BodyText += '<TD ALIGN = RIGHT>' + FORMAT(MachineJobLine."No of Resource") + '</TD>';
            UNTIL JobTask.NEXT = 0;

        BodyText += '</TABLE>';
        BodyText += '<br><br><br>';
        BodyText += '<B>' + 'Regards' + '</B>';
        BodyText += '<br>';
        CompInfo.GET;
        BodyText += '<B>' + CompInfo.Name + '</B>';
        BodyText += '<br><br><br><br><br>';
        BodyText += '<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>';

        IF JobTask.COUNT > 0 THEN begin
            //SMTPMail.Send;

            RecepientEmail.Add('shivshant.gupta@teamcomputers.com');

            CCEmail.Add('shashank.pathak@teamcomputers.com');
            BCCEmail.Add('shashank.pathak@teamcomputers.com');

            EmailMsg.Create(RecepientEmail, STRSUBSTNO(Text001, Job."No."), BodyText, true, CCEmail, BCCEmail);
            EmailObj.Send(EmailMsg, Enum::"Email Scenario"::Default);
        end;


        /*
        SMTPMailSetup.GET;
        SMTPMail.CreateMessage('', SMTPMailSetup."User ID", 'shivshant.gupta@teamcomputers.com', STRSUBSTNO(Text001, Job."No."), '', TRUE);
        SMTPMail.AppendBody('Sir/Mam,');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Greetings of the day');
        SMTPMail.AppendBody('<br><br><br>');
        SMTPMail.AppendBody('Candidate Requisition Details-<br><br>');
        SMTPMail.AppendBody('<TABLE border = "2">');
        //SMTPMail.AppendBody('<TH>Customer No</TH>');
        //SMTPMail.AppendBody('<TH>Project Code</TH>');
        SMTPMail.AppendBody('<TH>Project Name</TH>');
        SMTPMail.AppendBody('<TH>Job Type</TH>');
        SMTPMail.AppendBody('<TH>Project Start Date</TH>');
        SMTPMail.AppendBody('<TH>Project End Date</TH>');
        //  SMTPMail.AppendBody('<TH>Job Type</TH>');
        SMTPMail.AppendBody('<TH>People Count Needed</TH>');

        MachineJobLine.RESET;
        MachineJobLine.SETRANGE("Job Document No", Job."No.");
        //MachineJobLine.SETFILTER("Hring Candidate No",'<>%1',0);
        IF MachineJobLine.FINDSET THEN
            REPEAT
                SMTPMail.AppendBody('<TR>');
                //SMTPMail.AppendBody('<TD>'+Job."No."+'</TD>');
                SMTPMail.AppendBody('<TD>' + Job.Description + '</TD>');
                SMTPMail.AppendBody('<TD>' + MachineJobLine."Activity Code" + '</TD>');
                SMTPMail.AppendBody('<TD>' + FORMAT(Job."Starting Date") + '</TD>');
                SMTPMail.AppendBody('<TD>' + FORMAT(Job."Ending Date") + '</TD>');
                SMTPMail.AppendBody('<TD ALIGN = RIGHT>' + FORMAT(MachineJobLine."No of Resource") + '</TD>');
            UNTIL MachineJobLine.NEXT = 0;
        SMTPMail.AppendBody('</TABLE>');
        SMTPMail.AppendBody('<br><br><br>');
        SMTPMail.AppendBody('<B>' + 'Regards' + '</B>');
        SMTPMail.AppendBody('<br>');
        CompInfo.GET;
        SMTPMail.AppendBody('<B>' + CompInfo.Name + '</B>');
        SMTPMail.AppendBody('<br><br><br><br><br>');
        SMTPMail.AppendBody('<center>****Please note that this is a system generated email, Reply to this email would not be answered****</center>');
        IF MachineJobLine.COUNT > 0 THEN
            SMTPMail.Send;
            */

    end;
}