tableextension 50033 "Responsibility Center" extends "Responsibility Center"
{
    fields
    {
        field(50000; "Requsition No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
        field(50001; "HO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Indent No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}