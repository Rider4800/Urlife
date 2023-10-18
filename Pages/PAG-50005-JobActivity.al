page 50005 "Job Activity"
{
    PageType = List;
    SourceTable = "Job Activity";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}