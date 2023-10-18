pageextension 50023 "Job Planning Lines" extends "Job Planning Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Resource Group No."; Rec."Resource Group No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Location Code10165"; Rec."Location Code")
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