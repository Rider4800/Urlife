table 50013 SaleInvoicecreationLine
{
    DataClassification = ToBeClassified;
    caption = 'Sale Invoice creation line';
    //    DrillDownPageID = "Posted Sales Invoices";
    // LookupPageID = "Posted Sales Invoices";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Qunatity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Direct Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Deferral Code"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Type; Enum "Sales Line Type")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Line No."; Integer)
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