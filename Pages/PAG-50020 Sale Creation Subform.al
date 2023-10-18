page 50020 "Sale Creation SubForm"
{

    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = 50015;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Qunatity; Rec.Qunatity)
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = all;
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = all;
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ApplicationArea = all;

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {

        }
    }
}