pageextension 79915 "usersetupext" extends "Approval User Setup"
{
    layout
    {
        addbefore("Purchase Amount Approval Limit")
        {
            field("Indent Approval Limit"; Rec."Indent Approval Limit")
            {
                ApplicationArea = all;

            }
            // field("Requisition Approval Limit"; Rec."Requisition Approval Limit")
            // {
            //     ApplicationArea = all;

            // }

        }
    }
}