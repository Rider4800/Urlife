page 50505 Country_region
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 9;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;

                }
                field("Country Code for E-Invoicing"; Rec."Country Code for E-Invoicing")
                {
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}