pageextension 50025 "Company-Information" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("TDS Lower Deduction Cert. No."; Rec."TDS Lower Deduction Cert. No.")
            {
                ApplicationArea = All;
            }
            field("Team Logo"; Rec."Team Logo")
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