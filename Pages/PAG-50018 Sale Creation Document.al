page 50018 "Sale Creation Document"
{
    PageType = Document;
    ApplicationArea = All;
    SourceTable = 50014;


    layout
    {
        area(Content)
        {
            Group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;

                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension Code 1"; Rec."Global Dimension Code 1")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension Code 2"; Rec."Global Dimension Code 2")
                {
                    ApplicationArea = all;
                }
            }
            part(SalesLinesCreation; 50020)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }

    }

    actions
    {

    }
}