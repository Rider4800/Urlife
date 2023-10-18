pageextension 50032 "Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Dimension Set ID")
        {
            field("Requisition Document No."; Rec."Requisition Document No.")
            {
                ApplicationArea = All;
            }
            field("Released Doc No."; Rec."Released Doc No.")
            {
                ApplicationArea = All;
            }
            field("Released Doc Date"; Rec."Released Doc Date")
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