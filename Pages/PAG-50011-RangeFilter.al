page 50011 "Range Filter"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Range Filter";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                }
                field("From Days"; Rec."From Days")
                {
                    ApplicationArea = All;
                }
                field("To Days"; Rec."To Days")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Sundry Debtors Aging")
            {
                Caption = 'Sundry Debtors Aging';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //TEAM 14763 RunObject = Report 50082;
                ApplicationArea = All;
            }
            action("Trade Creditors Aging")
            {
                Caption = 'Trade Creditors Aging';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //TEAM 14763 RunObject = Report 50080;
                ApplicationArea = All;
            }
            action("Stock Aging ")
            {
                Caption = 'Stock Aging';
                Ellipsis = true;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                //TEAM 14763 RunObject = Report 50083;
                ApplicationArea = All;
            }
            action("Trade Creditors New")
            {
                //TEAM 14763 RunObject = Report 60013;
                ApplicationArea = All;
            }
        }
    }
}

