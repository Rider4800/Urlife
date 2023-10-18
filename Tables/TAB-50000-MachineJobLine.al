table 50000 "Machine Job Line"
{
    //     DrillDownPageID = 50000; //Gaurav
    //     LookupPageID = 50000;//Gaurav

    fields
    {
        field(2; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "Job Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Resource No."; Code[20])
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
        field(11; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(22; "Unit Price"; Decimal)
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
        field(23; "Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            DataClassification = ToBeClassified;
        }
        field(27; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50000; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Doctor,Nurse,Ambulence';
            OptionMembers = " ",Doctor,Nurse,Ambulence;
        }
        field(50001; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "No of Days"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(50004; "Sales Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Per Day Working Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '11443';

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(50006; "No of Resource"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '11443';

            trigger OnValidate()
            begin
                UpdateQuantity;
            end;
        }
        field(50007; "Activity Code"; Code[20])
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
        field(50008; "Activity Description"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Hring Candidate No"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Hring Candidate No" > "No of Resource" THEN
                    ERROR('Total no. of resource is exceeding than no of resource required.');
            end;
        }
        field(50010; "No. Of Cycle"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job Document No", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Per Day Working Hours";

        }
    }

    fieldgroups
    {
    }

    var
        JobActivity: Record 50001;
        RecResource: Record 156;

    local procedure UpdateQuantity()
    begin
        //Quantity := "No of Days" * "No of Resource" * "Per Day Working Hours";
        Quantity := "No of Resource";
        Amount := Quantity * "Unit Price";
        // IF Quantity <> 0 THEN
    end;
}