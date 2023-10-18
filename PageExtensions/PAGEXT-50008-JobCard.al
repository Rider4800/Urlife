pageextension 50008 "Job Card" extends "Job Card"
{
    layout
    {
        addafter("Bill-to Contact")
        {
            field("Total Contract Value"; Rec."Total Contract Value")
            {
                ApplicationArea = All;
            }
            field("Candidate Requisition Raised"; Rec."Candidate Requisition Raised")
            {
                ApplicationArea = All;
            }
            field("Modified Date"; Rec."Modified Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("&Job")
        {
            action("Create Job Task Lines")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateLinesFromJob;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RescorceJobLine: Record 50000;
                    JobTask: Record "Job Task";
                begin
                    CLEAR(RescorceJobLine);
                    RescorceJobLine.SETRANGE(RescorceJobLine."Job Document No", Rec."No.");
                    RescorceJobLine.SETFILTER(RescorceJobLine."Line No.", '<>%1', 0);
                    IF RescorceJobLine.FINDSET THEN BEGIN
                        REPEAT
                            JobTask.RESET;
                            JobTask.SETRANGE(JobTask."Job No.", RescorceJobLine."Job Document No");
                            JobTask.SETRANGE("Activity Code", RescorceJobLine."Activity Code");
                            IF NOT JobTask.FINDFIRST THEN BEGIN
                                JobTask.INIT;
                                JobTask."Job No." := RescorceJobLine."Job Document No";
                                JobTask.Description := COPYSTR(RescorceJobLine."Activity Description", 1, 50);
                                JobTask."Job Task Type" := JobTask."Job Task Type"::Posting;
                                JobTask."Activity Code" := RescorceJobLine."Activity Code";
                                JobTask."Activity Description" := RescorceJobLine."Activity Description";

                                JobTask.INSERT(TRUE);
                            END;
                        UNTIL RescorceJobLine.NEXT = 0;
                        MESSAGE('Job Task Created');
                    END;
                END;
            }
            action("Send Candidate Requisition")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = CreateLinesFromJob;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    MailSendForCandidate: Codeunit 50004;
                begin
                    IF NOT Rec."Candidate Requisition Raised" THEN BEGIN
                        MailSendForCandidate.SendCandidateRequisition(Rec);
                        Rec."Candidate Requisition Raised" := TRUE;
                        CurrPage.UPDATE(TRUE);
                    END ELSE
                        MESSAGE('Requisition already raised');
                end;
            }
        }
    }

    procedure InsertJobTaskLines(): Code[20]
    VAR
        JobTask: Record 1001;
        ReplacedCode: Code[20];
        CustCode: Code[20];
        PosVar: Integer;
        CustVar: Code[20];
        TestCode: Code[20];
        JobTask1: Record 1001;
        i: Integer;
        j: Integer;
    begin
        CLEAR(ReplacedCode);
        CLEAR(CustCode);
        CLEAR(TestCode);
        j := 0;

        JobTask.RESET;
        JobTask.SETCURRENTKEY("Job No.", "Job Task No.");
        JobTask.SETRANGE("Job No.", Rec."No.");
        IF JobTask.FINDSET THEN
            REPEAT
                CustVar := JobTask."Job No." + '/';
                PosVar := STRPOS(JobTask."Job Task No.", CustVar);
                IF PosVar > 0 THEN BEGIN
                    CLEAR(TestCode);
                    ReplacedCode := CONVERTSTR(JobTask."Job Task No.", '/', ',');
                    CustCode := SELECTSTR(2, ReplacedCode);
                    EVALUATE(i, CustCode);
                    IF (i >= j) THEN BEGIN
                        j := i;
                        TestCode := JobTask."Job Task No.";
                    END ELSE BEGIN
                        j := j;
                        TestCode := JobTask."Job Task No.";
                    END;
                END;
            UNTIL JobTask.NEXT = 0;

        CLEAR(ReplacedCode);
        CLEAR(CustCode);

        JobTask1.RESET;
        JobTask1.SETRANGE("Job Task No.", TestCode);
        JobTask1.SETRANGE("Job No.", Rec."No.");
        IF JobTask1.FINDLAST THEN BEGIN
            ReplacedCode := CONVERTSTR(JobTask1."Job Task No.", '/', ',');
            CustCode := SELECTSTR(1, ReplacedCode);
            j := j + 1;
            IF JobTask1."Job No." = CustCode THEN
                JobTask1."Job Task No." := JobTask1."Job No." + '/' + FORMAT(j)
            ELSE
                JobTask1."Job Task No." := Rec."No." + '/' + '1';
        END ELSE
            JobTask1."Job Task No." := Rec."No." + '/' + '1';
    end;
}