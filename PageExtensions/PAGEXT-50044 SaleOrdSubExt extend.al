pageextension 50044 SaleOrdSubExt extends 46
{
    layout
    {
        modify("Deferral Code")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        // addafter("Deferral Code")
        // {
        //     field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
        //     {
        //         Visible = true;
        //     }
        // }
    }

    actions
    {
        // Add changes to page actions here
    }
    var
        myInt: Integer;
}