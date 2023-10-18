pageextension 50018 "G/L-Account Card" extends "G/L Account Card"
{
    layout
    {
        addafter(Name)
        {
            field(Jobs; Rec.Jobs)
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