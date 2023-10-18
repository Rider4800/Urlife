tableextension 50111 HumanResExt extends 5218
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Allow multiple Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Check Multiple Posting Groups"; enum "Posting Group Change Method")
        {
            Caption = 'Check Multiple Posting Groups';
            DataClassification = SystemMetadata;
        }
    }

    var
        myInt: Integer;
}