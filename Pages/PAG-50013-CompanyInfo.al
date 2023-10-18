page 50013 CompanyInfo
{
    PageType = CardPart;
    SourceTable = "Company Information";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("."; Rec.Picture)
                {
                    Caption = '.';
                }
                field(".."; Rec."Team Logo")
                {
                    Caption = 'Solution Partner';
                }
            }
        }
    }

    actions
    {
    }
}