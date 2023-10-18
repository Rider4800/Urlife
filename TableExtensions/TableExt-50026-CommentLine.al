tableextension 50026 "Comment Line" extends "Comment Line"
{
    fields
    {
        field(50000; "Approval Type"; enum "Approval Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnBeforeInsert()
    begin
        Rec.Date := Today;
        Rec."User ID" := UserId;
    end;

    trigger OnBeforeModify()
    begin
        Rec.Date := Today;
        Rec."User ID" := UserId;
    end;
}