pageextension 50021 "Posted-Sales-Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Invoice")
        {
            action("Print Invoice Report")
            {
                Caption = 'Print Invoice Report';
                Image = Invoice;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SIH: Record "Sales Invoice Header";
                begin
                    SIH.RESET;
                    SIH.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(50000, TRUE, TRUE, SIH);
                end;
            }
        }
    }
}