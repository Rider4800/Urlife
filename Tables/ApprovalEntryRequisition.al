table 50110 "Approval Entry Requisition"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Requisition No."; code[20])
        {
            DataClassification = CustomerContent;
        }
        Field(3; "Approval DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Rejection DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Cancel DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Sender UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Approver UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Cancel UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Cancel Remarks"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Reject Remarks"; text[50])
        {
            DataClassification = CustomerContent;
        }

        field(11; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Sent for approval",Cancel,Approved,Rejected;
            Editable = true;
        }
        field(12; "Rejected UserID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Sent for approval"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Send DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    /* Procedure CreateEntry(DocNo: Code[50]; Status1: Option Open,"Sent for approval",Cancel,Approved; userID1: Code[50])
    begin
        ApprovalEntryRequisition.Init;
        ApprovalEntryRequisition."Entry No." := LastEntryNo;
        ApprovalEntryRequisition."Requisition No." := DocNo;
        usersetup.Get(UserId);
        ApprovalEntryRequisition."Cancel UserID" := user;
        ApprovalEntryRequisition.Status := Status1;
        ApprovalEntryRequisition.Insert;

    end;
 */
    var
        ApprovalEntryRequisition: Record "Approval Entry Requisition";
        LastEntryNo: Integer;
        usersetup: Record "User Setup";

}
