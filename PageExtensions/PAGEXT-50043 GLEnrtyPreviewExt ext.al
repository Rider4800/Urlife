pageextension 50043 GLEntriesPreviewExt extends 122
{
    layout
    {
        modify("G/L Account Name")
        {
            Visible = true;
        }
        modify(Description)
        {
            Visible = false;
        }
    }
    actions
    {
        // Add changes to page actions here
    }
    var
        myInt: Integer;
}