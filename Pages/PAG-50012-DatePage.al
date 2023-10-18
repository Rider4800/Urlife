page 50012 "Date Page"
{
    PageType = List;
    SourceTable = Date;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Type"; Rec."Period Type")
                {
                    ApplicationArea = All;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = All;
                }
                field("Period End"; Rec."Period End")
                {
                    ApplicationArea = All;
                }
                field("Period No."; Rec."Period No.")
                {
                    ApplicationArea = All;
                }
                field("Period Name"; Rec."Period Name")
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