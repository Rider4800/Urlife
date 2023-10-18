page 50008 "Machine Job Line"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Machine Job Line";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Document No"; Rec."Job Document No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Service Type"; Rec."Service Type")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."Resource No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                    ApplicationArea = All;
                    Caption = 'Job Description';
                }
                field("No of Days"; Rec."No of Days")
                {
                    ApplicationArea = All;
                }
                field("No. Of Cycle"; Rec."No. Of Cycle")
                {
                    ApplicationArea = All;
                }
                field("Per Day Working Hours"; Rec."Per Day Working Hours")
                {
                    ApplicationArea = All;
                }
                field("No of Resource"; Rec."No of Resource")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Total Hours';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Total Billable Amount';
                    Editable = false;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        RecJob.RESET;
        RecJob.SETRANGE("No.", Rec."Job Document No");
        IF RecJob.FINDFIRST THEN BEGIN
            Rec."Bill-to Customer No." := RecJob."Bill-to Customer No.";
            Rec."Contract Start Date" := RecJob."Starting Date";
            Rec."Contract End Date" := RecJob."Ending Date";
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        RecJob.RESET;
        RecJob.SETRANGE("No.", Rec."Job Document No");
        IF RecJob.FINDFIRST THEN BEGIN
            Rec."Bill-to Customer No." := RecJob."Bill-to Customer No.";
            Rec."Contract Start Date" := RecJob."Starting Date";
            Rec."Contract End Date" := RecJob."Ending Date";
        END;
    end;

    trigger OnOpenPage()
    begin
        RecJob.RESET;
        RecJob.SETRANGE("No.", Rec."Job Document No");
        IF RecJob.FINDFIRST THEN BEGIN
            Rec."Bill-to Customer No." := RecJob."Bill-to Customer No.";
            Rec."Contract Start Date" := RecJob."Starting Date";
            Rec."Contract End Date" := RecJob."Ending Date";
        END;
    end;


    trigger OnFindRecord(Which: Text): Boolean
    begin

    end;

    var
        RecJob: Record Job;
}