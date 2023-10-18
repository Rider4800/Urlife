pageextension 50147 JobSetupExt extends "Jobs Setup"
{
    layout
    {
        addafter("Job WIP Nos.")
        {
            field("Last Run Date & Time"; Rec."Last Run Date & Time")
            {
                ApplicationArea = All;
            }
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}