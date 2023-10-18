page 50120 "Job"
{
    Caption = 'Jobs';
    SourceTable = Job;
    DelayedInsert = true;
    PageType = API;
    EntityName = 'Job';
    EntitySetName = 'Job';
    APIGroup = 'Job';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    Permissions = tabledata Job = ri;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(No; Rec."No.")
                {
                    ApplicationArea = Jobs;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Jobs;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Jobs;
                }
                field(NextInvoiceDate; Rec."Next Invoice Date")
                {
                    ApplicationArea = Jobs;
                }
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Jobs;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Jobs;
                }
            }
        }
    }
}