tableextension 50134 EInCountryRegion extends "Country/Region"
{
    fields
    {
        field(50101; "Country Code for E-Invoicing"; Code[2])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}