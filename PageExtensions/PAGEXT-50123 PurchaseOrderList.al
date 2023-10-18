pageextension 50123 ExtendPurchaseOrderList extends 9307
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action(Print_Report)
            {
                Caption = 'Generate Purchase Order Report';
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    if PurchaseHeader.FindFirst() then
                        report.Run(50102, true, true, PurchaseHeader);
                end;
            }

        }
    }

    var
        myInt: Integer;
        PurchaseHeader: Record "Purchase Header";
}