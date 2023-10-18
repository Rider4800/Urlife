pageextension 50050 CahsPaymentVoucher extends 18554
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