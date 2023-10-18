tableextension 50002 tableextension70000009 extends "G/L Account"
{
    fields
    {
        field(50000; Jobs; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Requisition GL"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }


    trigger OnBeforeDelete()
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Reset();
        recUserSetup.SetRange("User ID", UserId);
        recUserSetup.SetRange("Permission Modify Create", true);
        if not recUserSetup.FindFirst() then
            Error('You do not have permission to delete the record.');
    end;

    trigger OnBeforeModify()
    var
        recUserSetup: Record "User Setup";
    begin
        recUserSetup.Reset();
        recUserSetup.SetRange("User ID", UserId);
        recUserSetup.SetRange("Permission Modify Create", true);
        if not recUserSetup.FindFirst() then
            Error('You do not have permission to modify the record.');
    end;



}