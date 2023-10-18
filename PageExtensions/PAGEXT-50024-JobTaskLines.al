pageextension 50024 "Job Task Lines" extends "Job Task Lines Subform"
{
    layout
    {
        modify("Job Task No.")
        {
            Editable = false;
        }
        modify("Start Date")
        {
            Visible = false;
        }
        modify("End Date")
        {
            Visible = false;
        }
        addafter("Job Task No.")
        {
        }
        addafter(Description)
        {
            field("Activity Code"; Rec."Activity Code")
            {
                ApplicationArea = All;
            }
            field("Activity Description"; Rec."Activity Description")
            {
                ApplicationArea = All;
            }
            field("Resoruce Sent to HRMS"; Rec."Resoruce Sent to HRMS")
            {
                ApplicationArea = All;
            }
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                ApplicationArea = All;
            }
            field("Resource No."; Rec."Resource No.")
            {
                ApplicationArea = All;
            }
            field("No. Of Cycle"; Rec."No. Of Cycle")
            {
                ApplicationArea = All;
            }
            field("Unit of Measure"; Rec."Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("No of Resource"; Rec."No of Resource")
            {
                ApplicationArea = All;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = All;
            }
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            {
                ApplicationArea = All;
            }
            field("Per Day Working Hours"; Rec."Per Day Working Hours")
            {
                ApplicationArea = All;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = All;
            }
            field("Service Type"; Rec."Service Type")
            {
                ApplicationArea = All;
            }
            field("Contract Start Date"; Rec."Contract Start Date")
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
            field("Sales Quote No."; Rec."Sales Quote No.")
            {
                ApplicationArea = All;
            }
            //->TEAM-Priyanshu
            field("Service Unit Price"; Rec."Service Unit Price")
            {
                ApplicationArea = All;
            }
            //<-TEAM-Priyanshu
        }
        addafter(Totaling)
        {
            field("Modified Date"; Rec."Modified Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}