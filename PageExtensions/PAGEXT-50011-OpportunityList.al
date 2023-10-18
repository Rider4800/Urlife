pageextension 50011 "Opportunity List" extends "Opportunity List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Print Details")
        {
            action("Opportunity List Report")
            {
                ApplicationArea = All;
                //RunObject = Report 50063;
                Image = Opportunity;
            }
        }
    }
}