table 50009 "Approval Log Entries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document Type"; enum "Requisition & Indent Doc Type")
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Sequence No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Sender ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Approver ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; enum "Requisition & Indent Status")
        {
            DataClassification = ToBeClassified;
        }
        field(9; "User Comment"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}