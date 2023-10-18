tableextension 50000 tableextension70000001 extends "Job Task"
{
    fields
    {
        //Unsupported feature: Property Deletion (NotBlank) on ""Job Task No."(Field 2)".

        field(50000; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Resoruce Sent to HRMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '7739';
        }
        field(50003; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Activity";

            trigger OnValidate()
            begin
                IF JobActivity.GET("Activity Code") THEN
                    "Activity Description" := JobActivity."Activity Description"
                ELSE
                    "Activity Description" := '';
            end;
        }
        field(50004; "Activity Description"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(50006; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource WHERE(Contract = FILTER(true));

            trigger OnValidate()
            var
                SalesLine: Record 37;
                PrepaymentMgt: Codeunit 441;
            begin
                IF RecResource.GET("Resource No.") THEN BEGIN
                    Description := RecResource.Name;
                    "Description 2" := RecResource."Name 2";
                END ELSE BEGIN
                    Description := '';
                    "Description 2" := '';
                END;
            end;
        }
        field(50007; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(50008; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(50009; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(50010; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                //IF "Unit Price" <> 0 THEN
                // Amount := Quantity * "Unit Price";
                UpdateQuantity;
            end;
        }
        field(50011; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;
        }
        field(50012; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50013; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(50014; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50015; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Doctor,Nurse,Ambulence';
            OptionMembers = " ",Doctor,Nurse,Ambulence;
        }
        field(50016; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "No of Days"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(50019; "Sales Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Per Day Working Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '11443';

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(50021; "No of Resource"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '11443';

            trigger OnValidate()
            begin
                //UpdateQuantity;
            end;
        }
        field(50022; "Hring Candidate No"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Hring Candidate No" > "No of Resource" THEN
                    ERROR('Total no. of resource is exceeding than no of resource required.');
            end;
        }
        field(50023; "No. Of Cycle"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //->TEAM-Priyanshu
        field(50024; "Service Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        //<-TEAM-Priyanshu
    }

    var
        RecResource: Record 156;

    trigger OnInsert()
    begin
        "Creation Date" := TODAY;
        "Modified Date" := "Creation Date";
    end;

    trigger OnModify()
    begin
        IF xRec.Description <> Description THEN
            "Modified Date" := TODAY;
    end;

    local procedure UpdateQuantity()
    begin
        //Quantity := "No of Days" * "No of Resource" * "Per Day Working Hours";
        Quantity := "No of Resource";
        Amount := Quantity * "Unit Price";
        // IF Quantity <> 0 THEN
    end;

    procedure InsertJobTaskLines()
    var
        JobTask: Record "Job Task";
        ReplacedCode: Code[20];
        CustCode: Code[20];
        PosVar: Integer;
        CustVar: Code[20];
        TestCode: Code[20];
        JobTask1: Record "Job Task";
        i: Integer;
        j: Integer;
    begin
        CLEAR(ReplacedCode);
        CLEAR(CustCode);
        CLEAR(TestCode);
        j := 0;
        JobTask.RESET;
        JobTask.SETCURRENTKEY("Job No.", "Job Task No.");
        JobTask.SETRANGE("Job No.", "Job No.");
        IF JobTask.FINDSET THEN
            REPEAT
                CustVar := JobTask."Job No." + '-';
                PosVar := STRPOS(JobTask."Job Task No.", CustVar);
                IF PosVar > 0 THEN BEGIN
                    CLEAR(TestCode);
                    ReplacedCode := CONVERTSTR(JobTask."Job Task No.", '-', ',');
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
        JobTask1.SETRANGE("Job No.", Rec."Job No.");
        IF JobTask1.FINDLAST THEN BEGIN
            ReplacedCode := CONVERTSTR(JobTask1."Job Task No.", '-', ',');
            CustCode := SELECTSTR(1, ReplacedCode);
            j := j + 1;
            IF JobTask1."Job No." = CustCode THEN
                "Job Task No." := JobTask1."Job No." + '-' + FORMAT(j)
            ELSE
                "Job Task No." := "Job No." + '-' + '1';
        END ELSE
            "Job Task No." := "Job No." + '-' + '1';
    end;

    var
        JobActivity: Record "Job Activity";
}