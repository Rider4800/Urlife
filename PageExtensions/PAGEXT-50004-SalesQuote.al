pageextension 50004 "Sales--Quote" extends "Sales Quote"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("Contract Start Date"; Rec."Contract Start Date")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    RecSalesLines: Record "Sales Line";
                begin
                    if Rec."Contract Start Date" <> 0D then begin
                        RecSalesLines.Reset;
                        RecSalesLines.SetRange("Document No.", Rec."No.");
                        if RecSalesLines.FindSet then begin
                            repeat
                                RecSalesLines."Contract Start Date" := Rec."Contract Start Date";
                                RecSalesLines.Modify(true);
                            until RecSalesLines.Next = 0;
                        end;
                    end;
                end;
            }
            field("Contract End Date"; Rec."Contract End Date")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    RecSalesLines: Record "Sales Line";
                begin
                    if Rec."Contract End Date" <> 0D then begin
                        RecSalesLines.Reset;
                        RecSalesLines.SetRange("Document No.", Rec."No.");
                        if RecSalesLines.FindSet then begin
                            repeat
                                RecSalesLines."Contract End Date" := Rec."Contract End Date";
                                RecSalesLines.Modify(true);
                            until RecSalesLines.Next = 0;
                        end;
                    end;
                end;
            }
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter(Approvals)
        {
            action("Print Invoice Report")
            {
                ApplicationArea = All;
                Image = Invoice;
                trigger OnAction()
                var
                    SH: Record "Sales Header";
                begin
                    SH.RESET;
                    SH.SETRANGE("No.", Rec."No.");
                    IF SH.FINDFIRST THEN
                        REPORT.RUNMODAL(50001, TRUE, TRUE, SH);
                end;
            }
            action("Open Job Card")
            {
                Promoted = true;
                ApplicationArea = All;
                Image = Job;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction()
                var
                    RecJob: Record Job;
                begin
                    if Rec."Job No." <> '' then begin
                        RecJob.RESET;
                        RecJob.SETRANGE(RecJob."No.", Rec."Job No.");
                        IF RecJob.FINDFIRST THEN
                            PAGE.RUNMODAL(PAGE::"Job Card", RecJob);
                    end else
                        Error('Job does not exist..');
                end;
            }
            action("Make Contract")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = JobLines;
                PromotedCategory = Process;
                Scope = Repeater;

                trigger OnAction()
                var
                    RecJob: Record Job;
                    MachineJobLine: Record "Machine Job Line";
                    SalesHeader: Record "Sales Header";
                    RecSalesLine: Record "Sales Line";
                    RecJobTask: Record "Job Task";
                begin
                    if not Confirm('Do you want to continue..', false) then
                        exit;

                    CLEAR(RecJob);
                    CLEAR(MachineJobLine);

                    IF Rec."Job Created" = false THEN BEGIN
                        SalesHeader.RESET;
                        SalesHeader.SETRANGE("No.", Rec."No.");
                        IF SalesHeader.FINDFIRST THEN BEGIN
                            SalesHeader.TESTFIELD("Contract Start Date");
                            SalesHeader.TESTFIELD("Contract End Date");

                            //  JobsSetup.TESTFIELD("Job Nos.");
                            //  RecJob."No." := NoSeriesMgt.GetNextNo(JobsSetup."Job Nos.",TODAY,TRUE);

                            RecJob.INIT;
                            RecJob.INSERT(TRUE);
                            RecJob.VALIDATE("Bill-to Customer No.", SalesHeader."Sell-to Customer No.");
                            //RecJob.VALIDATE("Bill-to Address","Sell-to Address");
                            RecJob."Bill-to Address 2" := SalesHeader."Sell-to Address 2";
                            //  RecJob."Bill-to City" := "Sell-to City";
                            //  RecJob."Bill-to Contact" := "Sell-to Contact";
                            RecJob.Description := SalesHeader."Sell-to Customer Name";
                            RecJob."Bill-to Contact No." := SalesHeader."Sell-to Contact No.";
                            RecJob."Sales Quote No" := SalesHeader."No.";
                            RecJob."Starting Date" := SalesHeader."Contract Start Date";
                            RecJob."Ending Date" := SalesHeader."Contract End Date";
                            RecJob."Last Date Modified" := TODAY;
                            RecJob.MODIFY;

                            RecSalesLine.RESET;
                            RecSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                            IF RecSalesLine.FINDSET THEN
                                REPEAT
                                    RecSalesLine.TESTFIELD("Activity Code");
                                    RecSalesLine.TESTFIELD(Quantity);
                                    RecSalesLine.TESTFIELD("Per Day Working Hours");
                                    //RecSalesLine.TESTFIELD("Service Type");
                                    RecSalesLine.TESTFIELD("No of Days");

                                    MachineJobLine.INIT;
                                    MachineJobLine."Job Document No" := RecJob."No.";
                                    MachineJobLine."Line No." := RecSalesLine."Line No.";
                                    MachineJobLine."Bill-to Customer No." := RecSalesLine."Sell-to Customer No.";
                                    MachineJobLine."Resource No." := RecSalesLine."No.";
                                    MachineJobLine."No. Of Cycle" := RecSalesLine."No. Of Cycle";
                                    MachineJobLine."Unit of Measure" := RecSalesLine."Unit of Measure";
                                    if RecSalesLine.Quantity <> 0 then
                                        MachineJobLine.VALIDATE("No of Resource", RecSalesLine.Quantity);
                                    if RecSalesLine."Unit Price" <> 0 then
                                        MachineJobLine.VALIDATE("Unit Price", RecSalesLine."Unit Price");
                                    MachineJobLine."Unit Cost (LCY)" := RecSalesLine."Unit Cost";
                                    if RecSalesLine."Per Day Working Hours" <> 0 then
                                        MachineJobLine.VALIDATE("Per Day Working Hours", RecSalesLine."Per Day Working Hours");
                                    if RecSalesLine."Line Amount" <> 0 then
                                        MachineJobLine.VALIDATE(Amount, RecSalesLine."Line Amount");
                                    MachineJobLine."Service Type" := RecSalesLine."Service Type";
                                    MachineJobLine."Contract Start Date" := SalesHeader."Contract Start Date";
                                    MachineJobLine."Contract End Date" := SalesHeader."Contract End Date";
                                    MachineJobLine."No of Days" := RecSalesLine."No of Days";
                                    MachineJobLine."Sales Quote No." := RecSalesLine."Document No.";
                                    if RecSalesLine."Activity Code" <> '' then
                                        MachineJobLine.VALIDATE("Activity Code", RecSalesLine."Activity Code");
                                    MachineJobLine."Activity Description" := RecSalesLine."Activity Description";
                                    MachineJobLine.INSERT;

                                    //TEAM 14763
                                    RecJobTask.Init;
                                    RecJobTask."Job No." := RecJob."No.";
                                    InsertJobTaskLines(RecJobTask, RecJob."No.");
                                    RecJobTask.Description := RecSalesLine."Activity Description";
                                    RecJobTask."Job Task Type" := RecJobTask."Job Task Type"::Posting;
                                    RecJobTask."Activity Code" := RecSalesLine."Activity Code";
                                    RecJobTask."Activity Description" := RecSalesLine."Activity Description";

                                    RecJobTask."Bill-to Customer No." := RecSalesLine."Sell-to Customer No.";
                                    RecJobTask."Resource No." := RecSalesLine."No.";
                                    RecJobTask."No. Of Cycle" := RecSalesLine."No. Of Cycle";
                                    RecJobTask."Unit of Measure" := RecSalesLine."Unit of Measure";
                                    if RecSalesLine.Quantity <> 0 then
                                        RecJobTask.VALIDATE("No of Resource", RecSalesLine.Quantity);
                                    if RecSalesLine."Unit Price" <> 0 then
                                        RecJobTask.VALIDATE("Unit Price", RecSalesLine."Unit Price");
                                    RecJobTask."Unit Cost (LCY)" := RecSalesLine."Unit Cost";
                                    if RecSalesLine."Per Day Working Hours" <> 0 then
                                        RecJobTask.VALIDATE("Per Day Working Hours", RecSalesLine."Per Day Working Hours");
                                    if RecSalesLine."Line Amount" <> 0 then
                                        RecJobTask.VALIDATE(Amount, RecSalesLine."Line Amount");
                                    RecJobTask."Service Type" := RecSalesLine."Service Type";
                                    RecJobTask."Contract Start Date" := SalesHeader."Contract Start Date";
                                    RecJobTask."Contract End Date" := SalesHeader."Contract End Date";
                                    RecJobTask."No of Days" := RecSalesLine."No of Days";
                                    RecJobTask."Sales Quote No." := RecSalesLine."Document No.";
                                    RecJobTask."Service Unit Price" := RecSalesLine."Service Unit Price";   //TEAM-Priyanshu
                                    RecJobTask.INSERT(TRUE);
                                //TEAM 14763

                                UNTIL RecSalesLine.NEXT = 0;

                            Rec."Job Created" := TRUE;
                            Rec."Job No." := RecJob."No.";
                            Rec.MODIFY;

                            MESSAGE('Job No %1 Created', RecJob."No.");
                        END
                    END ELSE
                        ERROR('Job has already been created');
                end;
            }
        }
    }

    procedure InsertJobTaskLines(var JobTask: Record "Job Task"; JobNo: Code[20])
    VAR
        JobTask1: Record 1001;
        j: Integer;
    begin
        Clear(j);

        JobTask1.RESET;
        JobTask1.SETRANGE("Job No.", JobNo);
        IF JobTask1.FINDLAST THEN BEGIN
            j := JobTask1.Count + 1;
            JobTask."Job Task No." := JobTask1."Job No." + '/' + FORMAT(j);
        END ELSE
            JobTask."Job Task No." := JobNo + '/' + '1';
    end;
}