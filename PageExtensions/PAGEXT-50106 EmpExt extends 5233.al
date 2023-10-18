pageextension 50106 EmpExt extends 5233
{
    layout
    {
        // Add changes to page layout here
        addafter("Automatically Create Resource")
        {
            field("Allow multiple Posting"; Rec."Allow multiple Posting")
            {
                ApplicationArea = all;
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