pageextension 50006 "Job Resource Manager RC" extends "Job Resource Manager RC"
{
    layout
    {

    }

    actions
    {
        modify("Time Sheets")
        {
            Visible = false;
        }
        modify("Manager Time Sheets")
        {
            Visible = false;
        }
        addafter("Resource - Cost &Breakdown")
        {
            action("Customer Summary Aging")
            {
                ApplicationArea = All;
                //RunObject = Report 50061;
                //Promoted =Yes;
                Image = Report;
            }
            action("Customer Detailed Aging")
            {
                ApplicationArea = All;
                //RunObject = Report 50062;
                Image = Report;
            }
            action("Customer - Top 10 List")
            {
                ApplicationArea = All;
                RunObject = Report 111;
                Image = Report;
            }
            action("Opportunity")
            {
                ApplicationArea = All;
                //RunObject = Report 50063;
                Image = Report;
            }
            action("Aged Accounts Receivable")
            {
                ApplicationArea = All;
                RunObject = Report 120;
                Image = Report;
            }
            action("Customer - Trial Balance")
            {
                ApplicationArea = All;
                RunObject = Report 129;
                Image = Report;
            }
        }
        addafter("Create Time Sheets")
        {
            action("Customer Payment Alert")
            {
                ApplicationArea = All;
                RunObject = Codeunit 50004;
                Image = Alerts;
            }
            action("Get TimeSheet")
            {
                ApplicationArea = All;
                RunObject = Codeunit 50002;
                Image = Alerts;
            }
            action("Run Job Contract Expiring")
            {
                ApplicationArea = All;
                RunObject = Codeunit 50005;
                Image = Alerts;
            }
        }
    }

}