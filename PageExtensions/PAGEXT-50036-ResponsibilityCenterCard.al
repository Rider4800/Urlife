pageextension 50036 MyExtension extends "Responsibility Center Card"
{
    layout
    {
        addafter("Location Code")
        {
            field("Requsition No. Series"; Rec."Requsition No. Series")
            {
                ApplicationArea = All;
            }
            field(HO; Rec.HO)
            {
                ApplicationArea = All;
            }
            field("Indent No. Series"; Rec."Indent No. Series")
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