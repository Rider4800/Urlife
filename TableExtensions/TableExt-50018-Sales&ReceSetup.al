tableextension 50030 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Requ-Req Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Adrenalin API URL"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Create Sale Inv"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}