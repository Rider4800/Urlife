pageextension 50031 "Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        addafter(Amount)
        {
            field("PO Expense Type"; Rec."PO Expense Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}