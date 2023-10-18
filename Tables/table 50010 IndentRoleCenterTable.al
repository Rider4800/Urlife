table 50010 IndentRoleCenterTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; PrePurchaseIndent; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Pre Indent Header");

        }
        field(3; PostIndentData; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Posted Indent Header");
        }
        field(4; Pendingindent; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Pre Indent Header" where(Status = const("Sent for approval")));
        }
    }

    keys
    {
        key(Key1; PrimaryKey)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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