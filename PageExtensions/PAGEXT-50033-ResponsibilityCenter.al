pageextension 50033 "Responsibility Center List" extends "Responsibility Center List"
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
}