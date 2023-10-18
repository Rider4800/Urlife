table 50001 "Job Activity"
{
    DrillDownPageID = 50005;
    //LookupPageID = 50001;

    fields
    {
        field(1; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Activity Description"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Activity Code")
        {
            Clustered = true;
        }
        key(Key2; "Activity Description")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Activity Code", "Activity Description")
        {
        }
        fieldgroup(Brick; "Activity Code", "Activity Description")
        {
        }
    }
}