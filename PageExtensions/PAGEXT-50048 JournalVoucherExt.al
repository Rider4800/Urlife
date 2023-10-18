pageextension 50048 JournalVoucherExt extends 18557
{
    layout
    {
        addafter("Account No.")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                Editable = true;
                ApplicationArea = all;
            }
            field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }
        modify("TDS Certificate Receivable")
        {
            Visible = true;
            Editable = true;
            ApplicationArea = all;
        }
    }
    actions
    {
        // Add changes to page actions here
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                IsConfirm: Boolean;
                varGenG: Record 81;
            begin
                // varGenG.Reset();
                // varGenG.SetRange("Document No.", Rec."Document No.");
                // varGenG.SetRange("Line No.", Rec."Line No.");
                // // varGenG.SetRange("Account Type", Rec."Account Type"::Employee);
                // if varGenG.FindSet() then begin
                //     repeat
                //         if varGenG."Posting Group" = '' then
                Message('Please Check Employee Posting Group');
                //         until varGenG.Next() = 0;
                //     end;
            end;
        }
    }
}