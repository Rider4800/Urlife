tableextension 50132 "Job Setup" extends "Jobs Setup"
{
    fields
    {
        //->TEAM-Priyanshu
        field(50000; "Last Run Date & Time"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //<-TEAM-Priyanshu
    }
}