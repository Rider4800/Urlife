page 50122 "Posted Requisition Subform"
{
    PageType = ListPart;
    SourceTable = "Posted Requisition Line";
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;



    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = all;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = all;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Full Description"; Rec."Full Description")
                {
                    ApplicationArea = all;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }

                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Required Quantity field.';
                }
                field(Reamrk; Rec.Reamrk)
                {
                    ApplicationArea = all;
                }

                field(UOM; Rec.UOM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM field.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field("PO No"; Rec."PO No")
                {
                    ToolTip = 'Specifies the value of the PO No field.';
                }
                field("PO Line No"; Rec."PO Line No")
                {
                    ToolTip = 'Specifies the value of the PO Line No field.';
                }
                field("MRN No"; Rec."MRN No")
                {
                    ToolTip = 'Specifies the value of the MRN No field.';
                }

            }
        }
    }
}