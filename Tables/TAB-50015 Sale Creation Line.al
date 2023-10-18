table 50015 "Sale Creation Line"
{
    DataClassification = ToBeClassified;
    caption = 'Sale Invoice creation line';
    //    DrillDownPageID = "Posted Sales Invoices";
    // LookupPageID = "Posted Sales Invoices";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Qunatity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Deferral Code"; code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(7; Type; Enum "Sales Line Type")
        {
            DataClassification = ToBeClassified;
        }
        field(8; "GST Group Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";
        }
        field(9; "HSN/SAC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC";
        }

    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := "Line No." + 10000;

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