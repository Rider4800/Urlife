pageextension 50051 ContraVoucherExt extends 18556
{
    layout
    {
        addafter("Location Code")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }

    }
    // actions
    // {
    //     // Add changes to page actions here
    //     modify(PostAndPrint)
    //     {
    //         trigger OnBeforeAction()
    //         var
    //             myInt: Integer;
    //             IsConfirm: Boolean;
    //             varGenG: Record 81;
    //         begin
    //             // varGenG.Reset();
    //             // varGenG.SetRange("Document No.", Rec."Document No.");
    //             // varGenG.SetRange("Line No.", Rec."Line No.");
    //             // // varGenG.SetRange("Account Type", Rec."Account Type"::Employee);
    //             // if varGenG.FindSet() then begin
    //             //     repeat
    //             //         if varGenG."Posting Group" = '' then
    //             Message('Please Check Employee Posting Group');
    //             //         until varGenG.Next() = 0;
    //             //     end;
    //         end;
    //     }
    // }
}