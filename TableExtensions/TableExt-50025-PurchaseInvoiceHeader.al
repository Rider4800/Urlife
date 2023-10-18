tableextension 50037 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "PO Expense Type"; Enum "PO Expense Type")
        {
            DataClassification = ToBeClassified;
        }
    }
}