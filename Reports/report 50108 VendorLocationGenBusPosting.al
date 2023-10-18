report 50108 VendorLocGenBusPostingUpdate
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    //One time use only
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            trigger OnAfterGetRecord()
            begin
                // RecVendor.Reset();
                // RecVendor.SetRange("No.", Vendor."No.");
                // if RecVendor.FindFirst() then begin
                //     RecVendor.Validate("Location Code", 'URLIFE-HYD');
                //     RecVendor.validate("Gen. Bus. Posting Group", 'DOMESTIC');
                //     RecVendor.Modify();
                // end;
            end;
        }
    }

    var
        RecVendor: Record Vendor;
}