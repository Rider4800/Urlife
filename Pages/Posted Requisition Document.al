page 50114 "Posted Requisition Document"
{
    PageType = Document;
    SourceTable = "Posted Requisition Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("No.") where(Status = const(Approved));
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    ApplicationArea = all;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                    ApplicationArea = all;
                }
                field("Required Date"; Rec."Required Date")
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                    ApplicationArea = all;
                }
                field("Requisition Status"; Rec."Requisition Status")
                {
                    ApplicationArea = all;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                }

                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = all;
                }
                field("Requisition Remarks"; Rec."Requisition Remarks")
                {
                    ApplicationArea = all;
                }

            }

            part("Requisition Subfrom"; 50122)
            {
                SubPageLink = "Requisition No." = field("No.");
                ApplicationArea = all;
            }


        }


    }
    actions
    {
        area(Processing)
        {
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
                    approvalEntryRequisition.SetRange("Requisition No.", Rec."No.");
                    if approvalEntryRequisition.FindFirst then
                        Page.RunModal(Page::"Approval History Requisition", approvalEntryRequisition)
                end;

            }

            action("Requisition Report")
            {
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Image = Print;
                Visible = False;
                trigger OnAction()
                var
                    PostedindnetHeader: Record "Posted Requisition Header";
                begin
                    PostedindnetHeader.Reset;
                    PostedindnetHeader.setrange("No.", rec."No.");
                    if PostedindnetHeader.FindFirst then
                        Report.RunModal(50122, true, true, PostedindnetHeader);

                end;
            }

        }

    }
    var
        approvalEntryRequisition: Record "Approval Entry Requisition";
}