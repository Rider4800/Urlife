codeunit 50111 int_to_words
{
    trigger OnRun()
    var


    begin
    end;

    procedure amountinwords(Amount: Decimal) final_value_in_words: Text[200]
    var
        myInt: Integer;
        reportcheck: Report "Posted Voucher";
        amountInWords: array[2] of Text[200];
    begin
        reportcheck.InitTextVariable();
        reportcheck.FormatNoText(amountInWords, Amount, '');
        final_value_in_words := amountInWords[1];
        exit(final_value_in_words);
    end;
}