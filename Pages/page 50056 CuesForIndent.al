page 50056 CuesForIndent
{
    Caption = 'Indent Approvals';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = IndentRoleCenterTable;

    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Pending Approvals';

                field("Pre Indent List"; Rec.PrePurchaseIndent)
                {
                    ApplicationArea = all;
                    DrillDownPageID = 79901;
                    // ToolTip = 'Specifies requests for certain documents, cards, or journal lines that your approver must approve before you can proceed.';
                }
                field("Sent for approval"; Rec.Pendingindent)
                {
                    ApplicationArea = all;
                    DrillDownPageID = 79901;
                    // ToolTip = 'Specifies requests for certain documents, cards, or journal lines that your approver must approve before you can proceed.';
                }
                field("Post Indent List"; Rec.PostIndentData)
                {
                    ApplicationArea = all;
                    DrillDownPageID = 79904;
                    // ToolTip = 'Specifies requests for certain documents, cards, or journal lines that your approver must approve before you can proceed.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}