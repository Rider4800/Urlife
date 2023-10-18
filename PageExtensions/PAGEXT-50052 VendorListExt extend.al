pageextension 50052 VendorListExt extends 27
{
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        RecUserSetup: Record "User Setup";
    begin
        RecUserSetup.Reset();
        RecUserSetup.SetRange("User ID", UserId);
        RecUserSetup.SetRange("Permission Modify Create", true);
        if not RecUserSetup.FindFirst() then
            Error('You do not have the permission to create new record.');
    end;

    var
        myInt: Integer;
}