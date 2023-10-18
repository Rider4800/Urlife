page 50101 "E-Invoice API Set Up"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "E-Invoice Set Up";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Client ID"; Rec."Client ID")
                {
                    ToolTip = 'Specifies the value of the Client ID field.';
                    ApplicationArea = All;
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'Specifies the value of the Client Secret field.';
                    ApplicationArea = All;
                }
                field("IP Address"; Rec."IP Address")
                {
                    ToolTip = 'Specifies the value of the IP Address field.';
                    ApplicationArea = All;
                }
                field("Authentication URL"; Rec."Authentication URL")
                {
                    ToolTip = 'Specifies the value of the Authentication URL field.';
                    ApplicationArea = All;
                }
                field("E-Invoice URl"; Rec."E-Invoice URl")
                {
                    ToolTip = 'Specifies the value of the E-Invoice URl field.';
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}