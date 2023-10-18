tableextension 50004 tableextension70000018 extends Job
{
    fields
    {
        field(50000; "Total Contract Value"; Decimal)
        {
            CalcFormula = Sum("Machine Job Line".Amount WHERE("Job Document No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Base Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document No." = FIELD("Sales Quote No")));
        }
        field(50002; "GST Amount"; Decimal)
        {
            //FieldClass = FlowField; //TEAM 14763
            //CalcFormula = Sum("Sales Line"."Total GST Amount" WHERE("Document No." = FIELD("Sales Quote No")));
        }
        field(50003; "Sales Quote No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Modified Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '7739';
        }
        field(50010; "Candidate Requisition Raised"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnInsert()
    begin
        "Modified Date" := "Creation Date";
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        IF (xRec.Description <> Description) OR (xRec."Bill-to Customer No." <> "Bill-to Customer No.") OR
           (xRec."Starting Date" <> "Starting Date") OR (xRec."Ending Date" <> "Ending Date") OR (xRec.Status <> Status) OR
           (xRec."Global Dimension 1 Code" <> "Global Dimension 1 Code") OR (xRec."Global Dimension 2 Code" <> "Global Dimension 2 Code") THEN
            "Modified Date" := TODAY;
    end;
}