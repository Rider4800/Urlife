page 50123 "Posted Requisition For PO"
{
    PageType = List;
    SourceTable = "Posted Requisition Line";
    Editable = false;
    ApplicationArea = all;
    UsageCategory = Administration;
    SourceTableView = sorting("Requisition No.", "Line No") where("Purchase Created" = const(false));
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = All;

                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No field.';
                }

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(UOM; rec.UOM)
                {
                    ApplicationArea = All;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ToolTip = 'Specifies the value of the Required Quantity field.';
                }
                field("Purchase Created"; Rec."Purchase Created")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchase Created field.';
                }
                field("PO No"; Rec."PO No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO No field.';
                }
                field("PO Line No"; Rec."PO Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Line No field.';
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

                trigger OnAction();
                begin

                end;
            }
        }
    }
    procedure GetDocNo(DocNo: code[20])
    begin
        GDocNo := DocNo;
    end;

    var
        GDocNo: Code[20];
        PurchaseLine: Record 39;
        PurchaseHead: Record 38;
        postedRequisitionheader: Record "Posted Requisition Header";

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction IN [Action::LookupOK, Action::OK] then begin
            CurrPage.SetSelectionFilter(Rec);
            if Rec.findset then begin
                repeat
                    if Rec."Approved Qty" > 0 then begin
                        if PurchaseHead.get(PurchaseHead."Document Type"::Order, GDocNo) then;

                        PurchaseLine.init;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := GDocNo;
                        PurchaseLine.Reset();//
                        PurchaseLine.SetRange("Document No.", GDocNo);//
                        if PurchaseLine.FindLast() then//
                            PurchaseLine."Line No." += 10000;
                        // PurchaseLine.Type := PurchaseLine.type::Item; //Original
                        //Added
                        if Rec.Type = Rec.Type::Item then
                            PurchaseLine.Type := PurchaseLine.type::Item;

                        if Rec.Type = Rec.Type::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";

                        if Rec.Type = Rec.Type::"Fixed Asset" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";

                        //Added Close
                        PurchaseLine.Validate("No.", Rec."No.");
                        PurchaseLine.validate("Location Code", PurchaseHead."Location Code");
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        PurchaseLine.validate("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
                        PurchaseLine.Validate(Quantity, rec."Approved Qty");
                        PurchaseLine."Requisition Document No." := Rec."Requisition No.";
                        PurchaseLine."Requisition Line No." := Rec."Line No";
                        PurchaseLine."Requisition Line No." := Rec."Line No";
                        PurchaseLine.insert;
                        Rec."Purchase Created" := true;
                        Rec."PO No" := PurchaseLine."Document No.";
                        Rec."PO Line No" := PurchaseLine."Line No.";
                        Rec.Modify;
                    end;

                until Rec.next = 0;
            end;
        end;
        CurrPage.update;
    end;
}