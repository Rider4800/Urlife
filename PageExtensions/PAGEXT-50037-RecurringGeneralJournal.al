pageextension 50037 PageExtension50000 extends "Recurring General Journal"
{
    layout
    {
        addafter("Document Type")
        {
            field("External Document No.11266"; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        addafter(Description)
        {
            field("GST Group Type"; Rec."GST Group Type")
            {
                ApplicationArea = all;
                Editable = true;
                Visible = false;
            }
            field("GST Group Code"; Rec."GST Group Code")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("GST Credit"; Rec."GST Credit")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("HSN/SAC Code"; Rec."HSN/SAC Code")
            {
                ApplicationArea = all;
            }
        }
    }
}
