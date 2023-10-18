tableextension 50040 GenJoouranTemp extends 80
{
    fields
    {
        field(50000; "Location Code"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Shortcut Dimension 2 Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

    }
    var
        myInt: Integer;
}