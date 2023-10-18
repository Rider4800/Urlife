pageextension 50016 "Customer-List" extends "Customer List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 208908"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field("GST Registration No.25440"; Rec."GST Registration No.")
            {
                ApplicationArea = All;
            }
            field("GST Registration No.12174"; Rec."GST Registration No.")
            {
                ApplicationArea = All;
            }
            field("GST Registration Type20480"; Rec."GST Registration Type")
            {
                ApplicationArea = All;
            }
            field("GST Customer Type87477"; Rec."GST Customer Type")
            {
                ApplicationArea = All;
            }
            field("State Code09068"; Rec."State Code")
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