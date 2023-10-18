table 50007 "Special Instruction"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Special Instruction";

    fields
    {
        field(1; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Start Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "End Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Vendor Code", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Vendor Code", Description)
        {

        }
    }
}