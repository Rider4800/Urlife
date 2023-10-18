pageextension 50041 SalesRelationshipExt extends 9026
{
    layout
    {
        // Add changes to page layout here
        addafter(ApprovalsActivities)
        {
            part(CueForIndent; 50056)
            {
                Caption = 'Indent Approval Cues';
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