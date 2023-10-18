pageextension 50019 "Chart-of-Accounts" extends "Chart of Accounts"
{

    layout
    {
        addafter(Name)
        {
            field(Jobs; Rec.Jobs)
            {
                ApplicationArea = All;
            }
            field("Requisition/Indent GL"; Rec."Requisition GL")
            {
                ApplicationArea = All;
            }
        }
    }
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     Error('Hi');
    // end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Error('Hi');
    end;


}