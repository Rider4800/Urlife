pageextension 50013 "Sales-Invoice" extends "Sales Invoice"
{
    layout
    {

    }

    actions
    {
        addafter("Co&mments")
        {
            action("Print Invoice Report")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
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