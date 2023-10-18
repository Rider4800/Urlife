tableextension 50012 tableextension70000021 extends Vendor
{
    fields
    {
        field(50001; "Special Instruction"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Special Instruction";
        }
    }

    trigger OnBeforeInsert()
    var
        RecUserSetup: Record "User Setup";
    begin
        RecUserSetup.Reset();
        RecUserSetup.SetRange("User ID", UserId);
        RecUserSetup.SetRange("Permission Modify Create", true);
        if not RecUserSetup.FindFirst() then
            Error('You do not have permission to create new record.');
    end;

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
        // Message(UserId);
    end;
}