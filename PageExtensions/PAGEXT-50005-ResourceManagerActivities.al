pageextension 50005 "Resource Manager Activities" extends "Resource Manager Activities"
{
    layout
    {
        addafter("Unassigned Resource Groups")
        {
            field("Open Sales Invoice"; Rec."Open Sales Invoice")
            {
                ApplicationArea = All;
            }
            field("Posted Sales Invoice"; Rec."Posted Sales Invoice")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("Approved Timesheet")
            {
                ApplicationArea = All;
                RunObject = Page 201;
            }
        }
    }
}