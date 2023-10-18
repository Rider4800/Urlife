pageextension 50015 "Customer-Card" extends "Customer Card"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field("Send Alert For Due Date"; Rec."Send Alert For Due Date")
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