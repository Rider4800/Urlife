pageextension 50053 ExtPurchInvSubForm extends 55
{
    layout
    {
        // Add changes to page layout here
        modify("Deferral Code")
        {
            Visible = true;
            ApplicationArea = all;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}