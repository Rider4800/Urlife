tableextension 50013 tableextension70000022 extends "Vendor Ledger Entry"
{
    fields
    {
        modify("Payment Reference")
        {
            trigger OnBeforeValidate()
            begin
                IF Rec."Payment Reference" <> '' THEN
                    Rec.TESTFIELD("Creditor No.");
            end;
        }
        field(50000; "PO Expense Type"; Enum "PO Expense Type")
        {
            DataClassification = ToBeClassified;
        }
    }


    //Unsupported feature: Code Modification on "CalcAppliedTDSBase(PROCEDURE 1500002)".

    //procedure CalcAppliedTDSBase();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS(Amount);
    IF Amount = 0 THEN
      EXIT(0);
    TDSEntry.SETRANGE("Transaction No.","Transaction No.");
    TDSEntry.SETRANGE("TDS Nature of Deduction",TDSNatureofDeduction);
    IF TDSEntry.FINDSET THEN
      REPEAT
        IF TDSEntry."TDS Base Amount" = 0 THEN
          TDSBaseAmount += TDSEntry."Work Tax Base Amount"
        ELSE
          TDSBaseAmount += TDSEntry."TDS Base Amount";
      UNTIL TDSEntry.NEXT = 0;

    IF TDSEntry."TDS Line Amount" > TDSBaseAmount THEN
      IF ABS(AppliedAmount) >= TDSBaseAmount THEN
        ApplicationRatio := 1
      ELSE
        ApplicationRatio := ABS(TDSBaseAmount - AppliedAmount) / TDSBaseAmount
    ELSE
      IF ABS(AppliedAmount) >= TDSBaseAmount THEN
        ApplicationRatio := 1
      ELSE
        ApplicationRatio := ABS(AppliedAmount) / TDSBaseAmount;

    EXIT(ROUND(TDSBaseAmount * ApplicationRatio));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13
    IF ABS(AppliedAmount) >= TDSBaseAmount THEN
      ApplicationRatio := 1
    ELSE
      ApplicationRatio := ABS(AppliedAmount) / TDSBaseAmount;

    EXIT(ROUND(TDSBaseAmount * ApplicationRatio));
    */
    //end;

}