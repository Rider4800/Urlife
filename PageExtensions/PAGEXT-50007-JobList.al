pageextension 50007 "Job List" extends "Job List"
{
    layout
    {
        modify("No.")
        {
            Caption = 'Project Code';
        }
        addafter("Job Posting Group")
        {
            field("Total Contract Value"; Rec."Total Contract Value")
            {
                ApplicationArea = All;
            }
            field("Bill-to City"; Rec."Bill-to City")
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