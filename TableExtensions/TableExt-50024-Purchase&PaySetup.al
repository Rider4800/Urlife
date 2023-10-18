tableextension 50036 "Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50001; "GL Account No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50002; "GL Account Per Day Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Indent No"; Code[20])
        {
            DataClassification = ToBeClassified;  //Gaurav
            TableRelation = "No. Series";

        }
        field(50004; "Requisition No"; Code[20])
        {
            DataClassification = ToBeClassified;  //Gaurav
            TableRelation = "No. Series";

        }
    }
}