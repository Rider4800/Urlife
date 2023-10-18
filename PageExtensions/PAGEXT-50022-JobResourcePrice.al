/*
pageextension 50022 "Job Resource Prices" extends "Job Resource Prices"
{
    layout
    {
        addafter("Job Task No.")
        {
            field("Activity Name"; Rec."Activity Name")
            {
                ApplicationArea = All;
            }
        }
        modify(Description)
        {
            Caption = 'Resource Name';
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
*/