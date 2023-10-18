pageextension 50054 ExtBankRecVoucher extends 18553
{
    layout
    {
        modify("TDS Certificate Receivable")
        {
            Visible = true;
            ApplicationArea = all;
            Editable = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}