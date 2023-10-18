tableextension 50035 "Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50000; "Requisition Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Work Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Requisition Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50023; "Requisition Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}