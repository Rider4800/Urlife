table 50011 "Employee & Timesheet Log Entry"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "API Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "CreatedDateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Created By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Employee ID"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Job No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Job Task No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Posting Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Quantity"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Unit Of Measure Code"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "JSON Data"; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    procedure SetJSONData(JSONDataDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("JSON Data");
        "JSON Data".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(JSONDataDescription);
        Modify();
    end;

    procedure GetJSONData() JSONDataDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("JSON Data");
        "JSON Data".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("JSON Data")));
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}