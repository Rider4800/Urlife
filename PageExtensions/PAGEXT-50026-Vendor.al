pageextension 50026 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("State Code")
        {
            field("Special Instruction"; Rec."Special Instruction")
            {
                ApplicationArea = All;
            }
        }
        modify("No.")
        {
            Visible = true;
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if Rec."GST Vendor Type" = Rec."GST Vendor Type"::" " then begin
            Error('Please update the value in "GST Vendor Type" field');
            exit(false);
        end;
    end;
}