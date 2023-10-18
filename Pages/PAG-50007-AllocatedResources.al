/*
page 50007 "Allocated Resources"
{
    Editable = false;
    PageType = List;
    SourceTable = "Job Resource Price";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Activity Name"; Rec."Activity Name")
                {
                    ApplicationArea = All;
                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Name';
                }
            }
        }
    }

    actions
    {
    }
}
*/