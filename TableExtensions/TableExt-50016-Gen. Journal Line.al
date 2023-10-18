tableextension 50028 tableextension70000050 extends "Gen. Journal Line"
{
    fields
    {

        modify("Payment Reference")
        {
            trigger OnBeforeValidate()
            begin
                IF "Payment Reference" <> '' THEN
                    TESTFIELD("Creditor No.");
            end;
        }
        modify("Posting Group")
        {
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group"
            ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group"
            else
            if ("Account Type" = const(Employee)) "Employee Posting Group";

        }
    }


    /* procedure CheckPostingGroupChange()
     var
         Customer: Record Customer;
         Vendor: Record Vendor;
         SalesReceivablesSetup: Record "Sales & Receivables Setup";
         PurchasesPayablesSetup: Record "Purchases & Payables Setup";
         PostingGroupChangeInterface: Interface "Posting Group Change Method";
         IsHandled: Boolean;
     begin
         IsHandled := false;
         OnBeforeCheckPostingGroupChange(Rec, xRec, IsHandled);
         if IsHandled then
             exit;
         if ("Posting Group" <> xRec."Posting Group") and (xRec."Posting Group" <> '') then begin
             TestField("Account No.");
             case "Account Type" of
                 "Account Type"::Customer:
                     begin
                         Customer.Get("Account No.");
                         SalesReceivablesSetup.Get();
                         if SalesReceivablesSetup."Allow Multiple Posting Groups" then begin
                             Customer.TestField("Allow Multiple Posting Groups");
                             PostingGroupChangeInterface := SalesReceivablesSetup."Check Multiple Posting Groups";
                             PostingGroupChangeInterface.ChangePostingGroup("Posting Group", xRec."Posting Group", Rec);
                         end;
                     end;
                 "Account Type"::Vendor:
                     begin
                         Vendor.Get("Account No.");
                         PurchasesPayablesSetup.Get();
                         if PurchasesPayablesSetup."Allow Multiple Posting Groups" then begin
                             Vendor.TestField("Allow Multiple Posting Groups");
                             PostingGroupChangeInterface := PurchasesPayablesSetup."Check Multiple Posting Groups";
                             PostingGroupChangeInterface.ChangePostingGroup("Posting Group", xRec."Posting Group", Rec);
                         end;
                     end;
                 else
                     error(CannotChangePostingGroupForAccountTypeErr, "Account Type");
             end;
         end;
     end;





     //procedure CalculateTCS();
     //Parameters and return type have not been exported.
     //>>>> ORIGINAL CODE:
     //begin
     /*
     IF "GST in Journal" AND ("TCS Nature of Collection" = '') THEN
       GSTApplicationManagement.CheckSalesJournalOnlineValidation(Rec);

     #4..40
         InitiateTCSCalculation(AccPeriodFilter,InvoiceAmount,
           PrevInvAmount,PrevTCSAmount,PrevSurchargeAmount,PrevContractAmount,FiscalYear);
         "Sales Amount" := TCSBaseLCY;
         "Surcharge Base Amount" := TCSBaseLCY;
         IF ("Applies-to ID" = '') AND ("Applies-to Doc. No." = '') THEN BEGIN
           IF NOCLine."Threshold Overlook" THEN
             PopulateTCSonThresholdOverlook(PrevInvAmount,AccPeriodFilter,NOCLine."Surcharge Overlook")
     #48..118
                   END;
           END;
         IF Amount <> 0 THEN
           PopulateTCSAmountNotZero(TCSAmount);
       END;
     END;
     */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..43
    #45..121
          PopulateTCSAmountNotZero(TCSAmount,SurchargeBaseAmount,SurchargeAmount);
      END;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "TCSGrossingup(PROCEDURE 1500008)".

    //procedure TCSGrossingup();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TempTCSBaseAmount := TCSBaseAmount;
    TotalPercentage := TCSPercentage + (TCSPercentage * SurchargePercentage / 100) +
      (TCSPercentage + (TCSPercentage * SurchargePercentage / 100)) *
      (eCessPercentage + SHECessPercentage) / 100;
    TCSBaseAmount -= RoundTCSAmount((TCSBaseAmount * TotalPercentage) / (100 + TotalPercentage));
    TCSAmount := RoundTCSAmount(TCSBaseAmount * TCSPercentage / 100);
    eCessAmount := RoundTCSAmount(TCSAmount * eCessPercentage / 100);
    SHECessAmount := RoundTCSAmount(TCSAmount * SHECessPercentage / 100);
    SurchargeAmount := RoundTCSAmount((TCSAmount + eCessAmount + SHECessAmount) * SurchargePercentage / 100);
    TCSBaseAmount := TempTCSBaseAmount - (TCSAmount + SurchargeAmount + eCessAmount + SHECessAmount);
    SurchargeBaseAmount := TCSBaseAmount;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    SurchargeAmount := RoundTCSAmount(TCSAmount * SurchargePercentage / 100);
    eCessAmount := RoundTCSAmount((TCSAmount + SurchargeAmount) * eCessPercentage / 100);
    SHECessAmount := RoundTCSAmount((TCSAmount + SurchargeAmount) * SHECessPercentage / 100);
    TCSBaseAmount := TempTCSBaseAmount - (TCSAmount + SurchargeAmount + eCessAmount + SHECessAmount);
    SurchargeBaseAmount := TCSBaseAmount;
    */
    //end;


    //Unsupported feature: Code Modification on "SetTDSEntryFiltersAppliedFalse(PROCEDURE 1500034)".

    //procedure SetTDSEntryFiltersAppliedFalse();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Party Type" = "Party Type"::Vendor THEN BEGIN
      Vendor.GET("Party Code");
      IF (Vendor."P.A.N. No." = '') AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
        ERROR(PANErr);
    END;

    TDSEntry.RESET;
    TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code",Applied);
    TDSEntry.SETRANGE("Party Type","Party Type");
    IF ("Party Type" = "Party Type"::Vendor) AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
      TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.")
    ELSE
      TDSEntry.SETRANGE("Party Code","Party Code");
    TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
    TDSEntry.SETRANGE("TDS Group","TDS Group");
    TDSEntry.SETRANGE("Assessee Code","Assessee Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #7..9
    TDSEntry.SETRANGE("Party Code","Party Code");
    #14..16
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateGSTAmounts(PROCEDURE 1500046)".

    //procedure CalculateGSTAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesReceivablesSetup.GET;
    ClearGSTAmounts;
    GSTManagement.CheckGSTAccountingPeriod("Posting Date");
    #4..18
        GSTPlaceOfSupplyState := GetPlaceOfSupply(Rec);
        Customer.GET("Account No.");
        "GST Customer Type" := Customer."GST Customer Type";
        "Post GST to Customer" := Customer."Post GST to Customer";
        IF "GST Customer Type" IN ["GST Customer Type"::" ","GST Customer Type"::Exempted] THEN
          EXIT;
        IF "GST Customer Type" = "GST Customer Type"::Unregistered THEN
    #26..54
          END;
        IF "GST Base Amount" <> 0 THEN
          "GST %" := "Total GST Amount" / "GST Base Amount" * 100;
        GSTManagement.UpdateRoundingGSTAmount(Rec,TransactionType::Sale,"Total TDS/TCS Incl. SHE CESS");
        GSTManagement.DeleteAdvPaymntGSTCalculationBuffer(Rec,TransactionType::Sale);
        IF "GST Customer Type" = "GST Customer Type"::Exempted THEN BEGIN
          "GST Base Amount" := TotalBaseAmount;
    #62..106
        AssignGSTBaseAndTotalAmtLCYFCY(Rec,TotalGST);
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..21
    #23..57
        GSTManagement.UpdateRoundingGSTAmount(Rec,TransactionType::Sale);
    #59..109
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateorClearVendCustInfo(PROCEDURE 1502050)".

    //procedure UpdateorClearVendCustInfo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF AccNo <> '' THEN BEGIN
      ClearGSTVendCustInfo;
      "Bill of Entry No." := '';
    #4..12
        IF Cust THEN BEGIN
          Customer.GET(AccNo);
          "GST Customer Type" := Customer."GST Customer Type";
          "Post GST to Customer" := Customer."Post GST to Customer";
          "GST Bill-to/BuyFrom State Code" := Customer."State Code";
          "Customer GST Reg. No." := Customer."GST Registration No.";
          IF "GST Customer Type" = "GST Customer Type"::Unregistered THEN
    #20..41
            ClearGSTVendCustInfo
    END ELSE
      ClearGSTVendCustInfo;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..15
    #17..44
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateAccNoCustomer(PROCEDURE 1500059)".

    //procedure UpdateAccNoCustomer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Cust.GET("Account No.");
    Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
    IF Cust."IC Partner Code" <> '' THEN BEGIN
    #4..17
    VALIDATE("Bill-to/Pay-to No.","Account No.");
    VALIDATE("Sell-to/Buy-from No.","Account No.");
    "GST Customer Type" := Cust."GST Customer Type";
    "Post GST to Customer" := Cust."Post GST to Customer";
    IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND "GST in Journal" THEN
      GSTManagement.GetJournalInvoiceTypeNoSeries(Rec,TransactionType1::Sales);
    IF "GST Customer Type" = "GST Customer Type"::Unregistered THEN
    #25..39
    UpdatePoT;
    UpdateGSTfromPartyVendCust("Account No.",TRUE,FALSE);
    "Journal Entry" := TRUE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..20
    #22..42
    */
    //end;


    //Unsupported feature: Code Modification on "GetInvoiceAmtTDS(PROCEDURE 1500063)".

    //procedure GetInvoiceAmtTDS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Party Type" = "Party Type"::Vendor THEN
      Vend.GET("Party Code");
    TDSEntry.RESET;
    TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
    TDSEntry.SETRANGE("Party Type","Party Type");
    IF ("Party Type" = "Party Type"::Vendor) AND (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") THEN
      TDSEntry.SETRANGE("Deductee P.A.N. No.",Vend."P.A.N. No.")
    ELSE
      TDSEntry.SETRANGE("Party Code","Party Code");

    TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
    TDSEntry.SETRANGE("TDS Group","TDS Group");
    TDSEntry.SETRANGE("Assessee Code","Assessee Code");
    #14..16
      InvoiceAmount := ABS(TDSEntry."Invoice Amount");
    END;
    EXIT(InvoiceAmount);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #3..5
    TDSEntry.SETRANGE("Party Code","Party Code");
    #11..19
    */
    //end;


    //Unsupported feature: Code Modification on "GetPaymentAmtTDS(PROCEDURE 1500067)".

    //procedure GetPaymentAmtTDS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Party Type" = "Party Type"::Vendor THEN
      Vendor.GET("Party Code");
    TDSEntry.RESET;
    TDSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TDS Group","Assessee Code","Document Type");
    TDSEntry.SETRANGE("Party Type","Party Type");
    IF ("Party Type" = "Party Type"::Vendor) AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
      TDSEntry.SETRANGE("Deductee P.A.N. No.",Vendor."P.A.N. No.")
    ELSE
      TDSEntry.SETRANGE("Party Code","Party Code");
    TDSEntry.SETFILTER("Posting Date",AccountingPeriodFilter);
    TDSEntry.SETRANGE("TDS Group","TDS Group");
    TDSEntry.SETRANGE("Assessee Code","Assessee Code");
    #13..15
      PaymentAmount := ABS(TDSEntry."Invoice Amount");
    END;
    EXIT(PaymentAmount);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #3..5
    TDSEntry.SETRANGE("Party Code","Party Code");
    #10..18
    */
    //end;


    //Unsupported feature: Code Modification on "InitiateTCSCalculation(PROCEDURE 1500077)".

    //procedure InitiateTCSCalculation();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Serv. Tax on Advance Payment" THEN
      TCSBaseLCY := ABS(Amount)
    ELSE BEGIN
      IF NOT "Exclude GST in TCS Base" THEN
        IF "TCS on Recpt. Of Pmt. Amount" = 0 THEN
          TCSBaseLCY :=
            ABS(Amount) + ABS("Service Tax Amount" + "Service Tax eCess Amount" +
              "Service Tax SHE Cess Amount" + "Service Tax SBC Amount" + "KK Cess Amount") +
            ABS(GSTManagement.GetTotalGSTAmountTDSTCS(Rec,TransactionType1::Sales))
        ELSE
          TCSBaseLCY :=
            ABS("TCS on Recpt. Of Pmt. Amount")
      ELSE
        IF "TCS on Recpt. Of Pmt. Amount" = 0 THEN
          TCSBaseLCY :=
            ABS(Amount) + ABS("Service Tax Amount" + "Service Tax eCess Amount" +
              "Service Tax SHE Cess Amount" + "Service Tax SBC Amount" + "KK Cess Amount")
        ELSE
          TCSBaseLCY :=
            ABS("TCS on Recpt. Of Pmt. Amount");
    END;
    IF "Currency Code" <> '' THEN BEGIN
      IF NOT "Exclude GST in TCS Base" THEN
        TCSBaseLCY := TCSBaseLCY - ABS(GSTManagement.GetTotalGSTAmountTDSTCS(Rec,TransactionType1::Sales));
      TCSBaseLCY := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            TCSBaseLCY,"Currency Factor"));
      IF NOT "Exclude GST in TCS Base" THEN
        TCSBaseLCY := TCSBaseLCY + ABS(GSTManagement.GetTotalGSTAmountTDSTCS(Rec,TransactionType1::Sales));
    END;

    DateFilterCalc.CreateTCSAccountingDateFilter(AccPeriodFilter,FiscalYear,"Posting Date",0);

    Customer.GET("Party Code");
    IF (Customer."P.A.N. No." = '') AND (Customer."P.A.N. Status" = Customer."P.A.N. Status"::" ") THEN
      ERROR(PANErr,Customer."No.");

    TCSEntry.RESET;
    TCSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TCS Type","Assessee Code","Document Type");
    TCSEntry.SETRANGE("Party Type","Party Type");
    IF Customer."P.A.N. Status" <> Customer."P.A.N. Status"::" " THEN
      TCSEntry.SETRANGE("Party Code","Party Code")
    ELSE
      TCSEntry.SETRANGE("Party P.A.N. No.",Customer."P.A.N. No.");
    TCSEntry.SETFILTER("Posting Date",AccPeriodFilter);
    TCSEntry.SETRANGE("TCS Type","TCS Type");
    TCSEntry.SETRANGE("Assessee Code","Assessee Code");
    TCSEntry.SETFILTER("Document Type",'%1|%2',TCSEntry."Document Type"::Invoice,TCSEntry."Document Type"::Payment);
    TCSEntry.CALCSUMS("Sales Amount","Service Tax Including eCess");
    InvoiceAmount := ABS(TCSEntry."Sales Amount") + ABS(TCSEntry."Service Tax Including eCess");
    PrevInvAmount := InvoiceAmount;

    TCSEntry.SETRANGE("Document Type");
    TCSEntry.CALCSUMS("TCS Amount","Surcharge Amount");

    PrevTCSAmount := ABS(TCSEntry."TCS Amount");
    PrevSurchargeAmount := ABS(TCSEntry."Surcharge Amount");

    TCSEntry.RESET;
    TCSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TCS Type","Assessee Code",Applied);
    TCSEntry.SETRANGE("Party Type","Party Type");
    IF Customer."P.A.N. Status" <> Customer."P.A.N. Status"::" " THEN
      TCSEntry.SETRANGE("Party Code","Party Code")
    ELSE
      TCSEntry.SETRANGE("Party P.A.N. No.",Customer."P.A.N. No.");
    TCSEntry.SETFILTER("Posting Date",AccPeriodFilter);
    TCSEntry.SETRANGE("TCS Type","TCS Type");
    TCSEntry.SETRANGE("Assessee Code","Assessee Code");
    TCSEntry.SETRANGE(Applied,FALSE);
    TCSEntry.SETRANGE("Per Contract",TRUE);
    TCSEntry.CALCSUMS("Sales Amount","Service Tax Including eCess");
    PrevContractAmount := ABS(TCSEntry."Sales Amount") + ABS(TCSEntry."Service Tax Including eCess");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
        TCSBaseLCY :=
          ABS(Amount) + ABS("Service Tax Amount" + "Service Tax eCess Amount" +
            "Service Tax SHE Cess Amount" + "Service Tax SBC Amount" + "KK Cess Amount") +
          ABS(GSTManagement.GetTotalGSTAmountTDSTCS(Rec,TransactionType1::Sales))
      ELSE
        TCSBaseLCY :=
          ABS(Amount) + ABS("Service Tax Amount" + "Service Tax eCess Amount" +
            "Service Tax SHE Cess Amount" + "Service Tax SBC Amount" + "KK Cess Amount");
    #21..34
    #39..41
    TCSEntry.SETRANGE("Party Code","Party Code");
    #46..62
    TCSEntry.SETRANGE("Party Code","Party Code");
    #67..73
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: SurchargeBaseAmount) (ParameterCollection) on "PopulateTCSAmountNotZero(PROCEDURE 1500068)".


    //Unsupported feature: Parameter Insertion (Parameter: SurchargeAmount) (ParameterCollection) on "PopulateTCSAmountNotZero(PROCEDURE 1500068)".



    //Unsupported feature: Code Modification on "PopulateTCSAmountNotZero(PROCEDURE 1500068)".

    //procedure PopulateTCSAmountNotZero();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Amount < 0 THEN BEGIN
      "TDS/TCS Base Amount" := -"TDS/TCS Base Amount";
      "Surcharge Base Amount" := -"Surcharge Base Amount";
    #4..7
      REPEAT
        TCSAmount += ((TCSBuffer[1]."TCS Base Amount" - TCSBuffer[1]."Contract TCS Ded. Base Amount") *
                      TCSBuffer[1]."TCS %" / 100);
      UNTIL TCSBuffer[1].NEXT(-1) = 0;

      IF Amount < 0 THEN
        "TDS/TCS Amount" := -RoundTCSAmount(TCSAmount)
      ELSE
        "TDS/TCS Amount" := RoundTCSAmount(TCSAmount);

      IF "TDS/TCS Base Amount" <> 0 THEN
        "TDS/TCS %" := ABS(ROUND(TCSAmount * 100 / "TDS/TCS Base Amount",0.001));
    END ELSE
      "TDS/TCS Amount" := RoundTCSAmount("TDS/TCS %" * "TDS/TCS Base Amount" / 100);

    IF ("Document Type" = "Document Type"::Payment) AND ("Applies-to Doc. No." = '') AND
       ("Applies-to ID" = '') AND ("TCS on Recpt. Of Pmt. Amount" = 0)
    THEN
      TCSGrossingup("TDS/TCS Base Amount","Surcharge Base Amount",
        "TDS/TCS %","Surcharge %","eCESS %","TDS/TCS Amount","Surcharge Amount","eCESS on TDS/TCS Amount",
        "SHE Cess % on TDS/TCS","SHE Cess on TDS/TCS Amount");

    "eCESS on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amount" * "eCESS %" / 100);
    "SHE Cess on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amount" * "SHE Cess % on TDS/TCS" / 100);
    "Surcharge Amount" :=
      RoundTCSAmount(("TDS/TCS Amount" + "eCESS on TDS/TCS Amount" + "SHE Cess on TDS/TCS Amount") * "Surcharge %" / 100);
    "TDS/TCS Amt Incl Surcharge" := "TDS/TCS Amount" + "Surcharge Amount";
    "Total TDS/TCS Incl. SHE CESS" := "TDS/TCS Amount" + "Surcharge Amount" + "eCESS on TDS/TCS Amount" +
      "SHE Cess on TDS/TCS Amount";

    IF "Currency Code" <> '' THEN BEGIN
      "TDS/TCS Base Amount" := ExchangeAmtLCYToFCY("TDS/TCS Base Amount",TRUE);
      "Surcharge Base Amount" := ExchangeAmtLCYToFCY("Surcharge Base Amount",TRUE);
      "Sales Amount" := ExchangeAmtLCYToFCY("Sales Amount",TRUE);
      "TDS/TCS Amount" := ExchangeAmtLCYToFCY("TDS/TCS Amount",TRUE);
      "Surcharge Amount" := ExchangeAmtLCYToFCY("Surcharge Amount",TRUE);
      "TDS/TCS Amt Incl Surcharge" := ExchangeAmtLCYToFCY("TDS/TCS Amt Incl Surcharge",TRUE);
    #45..47
      "Bal. TDS/TCS Including SHECESS" := "Total TDS/TCS Incl. SHE CESS";
      "Balance Surcharge Amount" := "Surcharge Amount";
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..10
        SurchargeBaseAmount += (TCSBuffer[1]."TCS %" *
                                (TCSBuffer[1]."Surcharge Base Amount" - TCSBuffer[1]."Contract TCS Ded. Base Amount") / 100);
        SurchargeAmount +=
          (TCSBuffer[1]."TCS %" *
           (TCSBuffer[1]."Surcharge Base Amount" - TCSBuffer[1]."Contract TCS Ded. Base Amount") / 100) *
          (TCSBuffer[1]."Surcharge %" / 100);
      UNTIL TCSBuffer[1].NEXT(-1) = 0;

      IF Amount < 0 THEN BEGIN
        "TDS/TCS Amount" := -RoundTCSAmount(TCSAmount);
        "Surcharge Amount" := -RoundTCSAmount(SurchargeAmount);
      END ELSE BEGIN
        "TDS/TCS Amount" := RoundTCSAmount(TCSAmount);
        "Surcharge Amount" := RoundTCSAmount(SurchargeAmount);
      END;
    #17..19
      IF SurchargeBaseAmount <> 0 THEN
        "Surcharge %" := ABS(ROUND(SurchargeAmount * 100 / SurchargeBaseAmount));
    END ELSE BEGIN
      "TDS/TCS Amount" := RoundTCSAmount("TDS/TCS %" * "TDS/TCS Base Amount" / 100);
      "Surcharge Amount" := RoundTCSAmount(("TDS/TCS %" * "Surcharge Base Amount" / 100) * ("Surcharge %" / 100));
    END;

    IF ("Document Type" = "Document Type"::Payment) AND ("Applies-to Doc. No." = '') AND
       ("Applies-to ID" = '')
    #25..29
    "TDS/TCS Amt Incl Surcharge" := "TDS/TCS Amount" + "Surcharge Amount";
    "eCESS on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amt Incl Surcharge" * "eCESS %" / 100);
    "SHE Cess on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amt Incl Surcharge" * "SHE Cess % on TDS/TCS" / 100);
    #35..38
    #42..50
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateGSTTDSTCSAmount(PROCEDURE 1500094)".

    //procedure CalculateGSTTDSTCSAmount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GSTManagement.CheckGSTAccountingPeriod("Posting Date");
    IF ("GST TDS" OR "GST TCS") AND ("Document Type" = "Document Type"::Payment) THEN BEGIN
      TESTFIELD("Location State Code");
    #4..15
          BEGIN
            Customer.GET("Account No.");
            "GST Customer Type" := Customer."GST Customer Type";
            "Post GST to Customer" := Customer."Post GST to Customer";
            IF "GST Customer Type" <> "GST Customer Type"::Registered THEN
              EXIT;
            IF NOT "GST on Advance Payment" THEN BEGIN
    #23..58
      IF "Account Type" = "Account Type"::Vendor THEN
        GSTManagement.DeleteGSTTCSCalculationBuffer(Rec,TransactionType::Purchase);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..18
    #20..61
    */
    //end;

    //Unsupported feature: Deletion (VariableCollection) on "SetTDSEntryFiltersAppliedFalse(PROCEDURE 1500034).Vendor(Variable 1500001)".


    //Unsupported feature: Deletion (VariableCollection) on "GetPaymentAmtTDS(PROCEDURE 1500067).Vendor(Variable 1500002)".


    //Unsupported feature: Deletion (VariableCollection) on "InitiateTCSCalculation(PROCEDURE 1500077).Customer(Variable 1500005)".
    var
        CannotChangePostingGroupForAccountTypeErr: Label 'Posting group cannot be changed for Account Type %1.', Comment = '%1 - account type';

}

