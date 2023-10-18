tableextension 50034 "Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50023; "Requisition Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Released Doc No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Released Doc Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
}