pageextension 50003 "Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Preview)
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