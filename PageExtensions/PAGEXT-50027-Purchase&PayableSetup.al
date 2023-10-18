pageextension 50027 "Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Credit Acc. for Non-Item Lines")
        {
            field("GL Account No."; Rec."GL Account No.")
            {
                ApplicationArea = All;
            }
            field("GL Account Per Day Limit"; Rec."GL Account Per Day Limit")
            {
                ApplicationArea = All;
            }
            field("Indent No"; Rec."Indent No")
            {
                ApplicationArea = All;
            }
            field("Requisition No"; Rec."Requisition No")
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