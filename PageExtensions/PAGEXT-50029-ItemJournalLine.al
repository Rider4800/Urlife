pageextension 50029 "Item Journal Lines" extends "Item Journal Lines"
{
    layout
    {
        addafter("Unit Cost")
        {
            field("Requisition Entry"; Rec."Requisition Entry")
            {
                ApplicationArea = All;
            }
            field("Work Order No."; Rec."Work Order No.")
            {
                ApplicationArea = All;
            }
            field("Requisition Line No."; Rec."Requisition Line No.")
            {
                ApplicationArea = All;
            }
            field("Requisition Document No."; Rec."Requisition Document No.")
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