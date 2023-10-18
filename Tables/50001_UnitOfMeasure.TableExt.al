tableextension 50101 UnitOfMeasure extends "Unit of Measure"
{
    fields
    {
        field(50101; "UOM For E Invoicing"; Code[8])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}