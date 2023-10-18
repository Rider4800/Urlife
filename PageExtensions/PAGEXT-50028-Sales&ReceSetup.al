pageextension 50028 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Freight G/L Acc. No.")
        {
            field("Requ-Req Nos."; Rec."Requ-Req Nos.")
            {
                ApplicationArea = All;
            }
            field("Create Sale Inv"; Rec."Create Sale Inv")
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