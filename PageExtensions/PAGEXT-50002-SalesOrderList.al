pageextension 50002 "Sales Order List" extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Pick Instruction")
        {
            action("Print Invoice Report")
            {
                ApplicationArea = All;
                Image = Invoice;
                trigger OnAction()
                var
                    SH: Record "Sales Header";
                begin
                    SH.RESET;
                    SH.SETRANGE("No.", Rec."No.");
                    IF SH.FINDFIRST THEN
                        REPORT.RUNMODAL(50001, TRUE, TRUE, SH);
                end;
            }
        }
    }
}