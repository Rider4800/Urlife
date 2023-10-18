pageextension 50001 pageextension50001 extends "Apply Customer Entries"
{

    //Unsupported feature: Code Modification on "PostDirectApplication(PROCEDURE 15)".

    //procedure PostDirectApplication();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF CalcType = CalcType::Direct THEN BEGIN
      IF ApplyingCustLedgEntry."Entry No." <> 0 THEN BEGIN
        Rec := ApplyingCustLedgEntry;
    #4..9
          IF NOT CustLedgEntry.HasGSTEntry("Transaction No.") AND (CustLedgEntry."TCS Nature of Collection" <> '') THEN
            IF (AppliedCustLedgEntry."GST Group Code" <> '') OR (AppliedCustLedgEntry."TCS Nature of Collection" <>'') THEN
              ERROR(GSTWithTCSErr);
        END;
        IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::"Finance Charge Memo" THEN BEGIN
          IF AppliedCustLedgEntry."GST on Advance Payment" THEN
    #16..25
          IF (CustLedgEntry."GST Group Code" <> '') AND (CustLedgEntry."TCS Nature of Collection" = '') THEN
            IF AppliedCustLedgEntry."TCS Nature of Collection" <> '' THEN
              ERROR(GSTWithTCSErr);
        END;
        PostApplication.SetValues("Document No.",ApplicationDate);
        IF ACTION::OK = PostApplication.RUNMODAL THEN BEGIN
    #32..48
        ERROR(Text002);
    END ELSE
      ERROR(Text003);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
          IF CustLedgEntry.HasGSTEntry("Transaction No.") AND (CustLedgEntry."TCS Nature of Collection" = '') THEN
            IF AppliedCustLedgEntry."TCS Nature of Collection" <>'' THEN
              ERROR(GSTWithTCSErr)
    #13..28
          IF (CustLedgEntry."GST Group Code" = '') AND (CustLedgEntry."TCS Nature of Collection" <> '') THEN
            IF AppliedCustLedgEntry.HasGSTEntry(AppliedCustLedgEntry."Transaction No.") THEN
              ERROR(GSTWithTCSErr);
    #29..51
    */
    //end;
}

