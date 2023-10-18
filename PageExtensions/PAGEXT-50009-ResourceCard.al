pageextension 50009 "Resource Card" extends "Resource Card"
{
    layout
    {
        addafter("Time Sheet Approver User ID")
        {
            field(Contract; Rec.Contract)
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