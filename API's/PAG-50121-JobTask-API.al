page 50121 "Job Task"
{
    Caption = 'Job Task';
    SourceTable = "Job Task";
    DelayedInsert = true;
    PageType = API;
    EntityName = 'JobTask';
    EntitySetName = 'JobTask';
    APIGroup = 'JobTask';
    APIPublisher = 'TCPL';
    APIVersion = 'v1.0';
    Permissions = tabledata "Job Task" = ri;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Jobs;
                }
                field(JobTaskNo; Rec."Job Task No.")
                {
                    ApplicationArea = Jobs;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                }
                field(JobTaskType; Rec."Job Task Type")
                {
                    ApplicationArea = Jobs;
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Jobs;
                }
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Jobs;
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Jobs;
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Jobs;
                }
            }
        }
    }
}