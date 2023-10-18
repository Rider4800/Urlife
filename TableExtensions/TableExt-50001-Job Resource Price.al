/*
tableextension 50001 tableextension70000002 extends "Job Resource Price"
{
    fields
    {
        modify("Job Task No.")
        {
            trigger OnBeforeValidate()
            var
                JT: Record "Job Task";
            begin
                IF Rec."Job Task No." <> '' THEN BEGIN
                    if JT.GET("Job No.", "Job Task No.") then
                        "Activity Name" := JT.Description;
                end;
            end;
        }

        field(50000; "Activity Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }
}
*/