tableextension 50106 GSTRegistrationNo extends "GST Registration Nos."
{
    fields
    {
        field(50101; "User Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}