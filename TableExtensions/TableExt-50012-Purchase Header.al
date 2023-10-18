tableextension 50019 "Purchase Header Ext." extends "Purchase Header"
{
    fields
    {
        modify("Payment Reference")
        {
            trigger OnBeforeValidate()
            begin
                IF "Payment Reference" <> '' THEN
                    TESTFIELD("Creditor No.");
            end;
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnBeforeValidate()
            var
                RecVendor: Record Vendor;
            begin
                if "Buy-from Vendor No." <> '' then begin
                    if RecVendor.GET('') then begin
                        RecVendor.TestField("Special Instruction");
                        Rec."Special Instruction" := RecVendor."Special Instruction";
                    end;
                end;
            end;
        }
        field(50000; "PO Expense Type"; Enum "PO Expense Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Special Instruction"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Special Instruction";
        }
    }
}