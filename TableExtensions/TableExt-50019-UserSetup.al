tableextension 50031 "User Setup" extends "User Setup"
{
    fields
    {
        field(50000; "NDT user"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Location Code"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Allow Item Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "FA Creation Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Vendor Creation Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Customer Creation Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Item Creation Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "GL Creation Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Undo Receipts Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Allow Posting Date Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Location Edit Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "No series Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "User Setup Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Allow QC Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Allow Advance Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Purchase Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Purchase Order Reopen"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Purchase Order Make"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Department Head"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Store In-Charge"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Department Head Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID" where("Department Head" = const(true));
        }
        field(50021; "Store In-Charge Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID" where("Store In-Charge" = const(true));
        }
        field(50022; "Requisition Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Indent Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Indent Approval Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50025; "Department Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Requisition Approval Limit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50027; "Permission Modify Create"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}