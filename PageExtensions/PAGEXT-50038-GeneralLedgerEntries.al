pageextension 50038 PageExtension50038 extends "General Ledger Entries"
{
    Editable = false;
    layout
    {
        modify("Global Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Global Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        addafter("Gen. Bus. Posting Group")
        {
            field("Debit Amount11199"; Rec."Debit Amount")
            {
                ApplicationArea = All;
            }
            field("Credit Amount12771"; Rec."Credit Amount")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Source Code54687"; Rec."Source Code")
            {
                ApplicationArea = All;
            }
            field("Source Type56831"; Rec."Source Type")
            {
                ApplicationArea = All;
            }
            field("Source No.81478"; Rec."Source No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
