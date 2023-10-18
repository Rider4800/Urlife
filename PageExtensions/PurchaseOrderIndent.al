pageextension 79908 GetIndentFromPO extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore(CopyDocument)
        {
            action(GetIndentLine)
            {
                ApplicationArea = Suite;
                Caption = 'Get Indent Lines';
                Ellipsis = true;
                Image = GetLines;

                trigger OnAction()
                begin
                    clear(IndentPage);
                    PostedIndentLine.reset;
                    PostedIndentLine.FilterGroup(2);
                    PostedIndentLine.SetRange("Purchase Created", false);
                    PostedIndentLine.SetFilter("Approved Qty", '>%1', 0);
                    PostedIndentLine.FilterGroup(0);
                    IndentPage.SetTableView(PostedIndentLine);
                    IndentPage.GetDocNo(Rec."No.");
                    IndentPage.LookupMode(true);
                    IndentPage.RunModal();
                end;

            }
            //new addition
            action(GetRequisitionLine)
            {
                ApplicationArea = Suite;
                Caption = 'Get Requisition Lines';
                Ellipsis = true;
                Image = GetLines;

                trigger OnAction()
                begin
                    clear(IndentPage);
                    PostedRequisitionLine.reset;
                    PostedRequisitionLine.FilterGroup(2);
                    PostedRequisitionLine.SetRange("Purchase Created", false);
                    PostedRequisitionLine.SetFilter("Approved Qty", '>%1', 0);
                    PostedRequisitionLine.FilterGroup(0);
                    RequisitionPage.SetTableView(PostedRequisitionLine);
                    RequisitionPage.GetDocNo(Rec."No.");
                    RequisitionPage.LookupMode(true);
                    RequisitionPage.RunModal();
                end;

            }
        }
        addafter("Post and &Print")
        {
            action(Print_Report)
            {
                Caption = 'Generate Purchase Order Report';
                ApplicationArea = All;
                Ellipsis = true;

                trigger OnAction()
                begin
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    if PurchaseHeader.FindFirst() then
                        report.Run(50102, true, true, PurchaseHeader);
                end;
            }

        }
        addafter(Category_Category10)
        {
            actionref(Print_Report_Promoted; Print_Report)
            {
            }
        }

        // Add changes to page actions here
    }

    var
        PostedIndentLine: Record "Posted Indent Line";
        IndentPage: page "Posted Indent For PO";
        PostedRequisitionLine: Record "Posted Requisition Line";
        RequisitionPage: page "Posted Requisition For PO";
        PurchaseHeader: Record "Purchase Header";

}