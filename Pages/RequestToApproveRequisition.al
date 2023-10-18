page 50116 "Request To Approve Requisition"
{
    PageType = List;
    SourceTable = "Approval Entry Requisition";
    UsageCategory = Administration;
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    SourceTableView = sorting("Entry No.") where("Sent for approval" = const(true));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = all;
                }
                field("Sender UserID"; Rec."Sender UserID")
                {
                    ApplicationArea = all;
                }
                field("Send DateTime"; Rec."Send DateTime")
                {
                    ApplicationArea = all;
                }
                field("Approver UserID"; Rec."Approver UserID")
                {
                    ApplicationArea = all;
                }
                field("Approval DateTime"; Rec."Approval DateTime")
                {
                    ApplicationArea = all;
                }
                field("Cancel UserID"; Rec."Cancel UserID")
                {
                    ApplicationArea = all;
                }
                field("Cancel DateTime"; Rec."Cancel DateTime")
                {
                    ApplicationArea = all;
                }
                field("Cancel Remarks"; Rec."Cancel Remarks")
                {
                    ApplicationArea = all;
                }
                field("Rejected UserID"; Rec."Rejected UserID")
                {
                    ApplicationArea = all;
                }
                field("Reject Remarks"; Rec."Reject Remarks")
                {
                    ApplicationArea = all;
                }
                field("Rejection DateTime"; Rec."Rejection DateTime")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }

            }


        }


    }

    actions
    {
        area(Processing)
        {
            action("Document")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Document;
                trigger OnAction()
                begin
                    RequisitionHeader.Reset();
                    RequisitionHeader.SetRange("No.", Rec."Requisition No.");
                    if RequisitionHeader.FindFirst then
                        Page.RunModal(Page::"Requisition Approve/Reject", RequisitionHeader)
                end;

            }

            action("Document History")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = History;
                trigger OnAction()
                begin
                    approvalEntryRequisition.Reset();
                    approvalEntryRequisition.SetRange("Requisition No.", Rec."Requisition No.");
                    if approvalEntryRequisition.FindFirst then
                        Page.RunModal(Page::"Approval History Requisition", approvalEntryRequisition)
                end;

            }
        }
    }

    trigger OnOpenPage()
    begin
        // rec.FILTERGROUP(2);

        // rec.SETRANGE("Approver UserID", UserId);
        // rec.FILTERGROUP(0);


    end;

    var
        RequisitionHeader: Record 50113;
        approvalEntryRequisition: Record 50110;
        usersetup: Record 91;
}
