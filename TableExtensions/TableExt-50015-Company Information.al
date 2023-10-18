tableextension 50027 tableextension70000049 extends "Company Information"
{
    fields
    {
        field(50000; "TDS Lower Deduction Cert. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'TMC::11905';
        }
        field(50001; "Team Logo"; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }
}