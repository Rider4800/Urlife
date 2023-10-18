pageextension 50010 "Contact List" extends "Contact List"
{
    layout
    {
        addafter("Mobile Phone No.")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}