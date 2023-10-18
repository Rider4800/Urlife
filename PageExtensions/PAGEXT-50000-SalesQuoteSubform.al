pageextension 50000 "Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        modify(Type)
        {
            Visible = false;
        }
        modify("No.")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Editable = false;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
        modify("Unit Cost (LCY)")
        {
            editable = false;
        }
        addbefore("Location Code")
        {
            field("Service Type"; Rec."Service Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Contract Start Date"; Rec."Contract Start Date")
            {
                ApplicationArea = All;
            }
            field("Activity Code"; Rec."Activity Code")
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("Activity Description"; Rec."Activity Description")
            {
                ApplicationArea = All;
            }
            field("Contract End Date"; Rec."Contract End Date")
            {
                ApplicationArea = All;
            }
            field("No of Days"; Rec."No of Days")
            {
                ApplicationArea = All;
            }
            field("No. Of Cycle"; Rec."No. Of Cycle")
            {
                ApplicationArea = All;
            }
            field("Per Day Working Hours"; Rec."Per Day Working Hours")
            {
                ApplicationArea = All;
            }
            field("Service Unit Price"; Rec."Service Unit Price")
            {
                ApplicationArea = All;
            }
            field("Service Amount"; Rec."Service Amount")
            {
                ApplicationArea = All;
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        Rec.Type := Rec.Type::Resource;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecSalesHeader: Record "Sales Header";
    begin
        Rec.Type := Type::Resource;
        Rec.Validate("No.", 'R0010');
        //Rec."No." := 'R0010';

        //TEAM 14763
        RecSalesHeader.Reset;
        RecSalesHeader.SetRange("No.", Rec."Document No.");
        if RecSalesHeader.FindFirst then begin
            Rec."Contract Start Date" := RecSalesHeader."Contract Start Date";
            Rec."Contract End Date" := RecSalesHeader."Contract End Date";
        end;
        //TEAM 14763
    end;
}