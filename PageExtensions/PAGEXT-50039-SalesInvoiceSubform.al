pageextension 50039 PageExtension50039 extends "Sales Invoice Subform"
{
    layout
    {
        addafter("GST Group Code")
        {
            field("Deferral Code05269"; Rec."Deferral Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
