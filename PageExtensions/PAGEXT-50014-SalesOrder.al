pageextension 50014 "Sales-Order" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addafter("Exclude GST in TCS Base")
        {
            field("Bal. Account Type"; Rec."Bal. Account Type")
            {
                ApplicationArea = all;
                Visible = False;
            }
            field("Bal. Account No."; Rec."Bal. Account No.")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }
    }

    actions
    {
        addafter("Pick Instruction")
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