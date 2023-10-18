page 50055 "Comment"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Comment Line";
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Approval Type"; Rec."Approval Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    Var
        ApprovalType: enum "Approval Type";

    trigger OnDeleteRecord(): Boolean
    begin
        if ApprovalType = Rec."Approval Type" then begin
            if Rec."User ID" <> UserId then
                Error('You are not authorised...');
        end else
            Error('You are not authorised...');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Date := Today;
    end;
}