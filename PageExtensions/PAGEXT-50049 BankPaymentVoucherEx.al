pageextension 50049 BankPaymentVoucherExt extends 18550
{
    layout
    {
        addafter("Account No.")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                Editable = true;
                ApplicationArea = all;
            }
        }
    }

}