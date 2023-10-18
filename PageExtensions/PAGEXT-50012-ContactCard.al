pageextension 50012 "Contact Card" extends "Contact Card"
{
    layout
    {
        addafter("Salutation Code")
        {
            field("Describe Requirement"; Rec."Describe Requirement")
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