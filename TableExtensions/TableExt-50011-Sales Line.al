tableextension 50018 tableextension70000031 extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account"),
                                     "System-Created Entry" = CONST(false)) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                                          "Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false),
                                                                                          Jobs = FILTER(true))
            ELSE
            IF (Type = CONST("G/L Account"),
                                                                                                   "System-Created Entry" = CONST(true)) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource WHERE(Contract = FILTER(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";

            trigger OnBeforeValidate()
            begin

                VALIDATE(Quantity, "No of Days");
            end;

            trigger OnAfterValidate()
            begin
                COntractDays;
            end;
        }

        modify("Unit Price")

        {

            trigger OnBeforeValidate()
            begin
                IF "Unit Price" <> 0 THEN BEGIN
                    IF "Document Type" = "Document Type"::Quote THEN
                        "Line Amount" := "No of Days" * Quantity * "Unit Price"
                end;
            end;
        }

        modify("TCS Nature of Collection")
        {
            trigger OnBeforeValidate()
            begin

            end;
        }
        //16225<<
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin

                if "Document Type" = "Document Type"::Quote then begin
                    if (Quantity <> 0) and ("Service Amount" <> 0) then begin
                        Validate("Unit Price", "Service Amount");
                        Validate("Line Amount", Quantity * "Service Amount");
                    end;
                end;
            end;
        }
        //16225>>


        //Unsupported feature: Code Modification on ""TCS Nature of Collection"(Field 16502).OnLookup".

        //trigger OnLookup(var Text: Text): Boolean
        //>>>> ORIGINAL CODE:
        //begin
        /*
        NOCLine.RESET;
        NOCLine.SETRANGE(Type,NODLines.Type::Customer);
        NOCLine.SETRANGE("No.","Bill-to Customer No.");
        NOCLine.SETRANGE("TDS for Customer",FALSE);
        IF NOCLine.FIND('-') THEN
          REPEAT
            NatureOfCollection.SETRANGE(Code,NOCLine."NOD/NOC");
            NatureOfCollection.SETRANGE("TCS on Recpt. Of Pmt.",FALSE);
            IF NatureOfCollection.FINDFIRST THEN BEGIN
              TempNatureOfCollection := NatureOfCollection;
              TempNatureOfCollection.INSERT;
            END;
          UNTIL NOCLine.NEXT = 0;

        IF PAGE.RUNMODAL(PAGE::"TCS Nature of Collections",TempNatureOfCollection) = ACTION::LookupOK THEN
          "TCS Nature of Collection" := TempNatureOfCollection.Code;
        VALIDATE("TCS Nature of Collection");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        NOCLine.RESET;
        NOCLine.SETRANGE(Type,NODLines.Type::Customer);
        NOCLine.SETRANGE("No.","Sell-to Customer No.");
        #4..6
            NatureOfCollection.GET(NOCLine."NOD/NOC");
            TempNatureOfCollection := NatureOfCollection;
            TempNatureOfCollection.INSERT;
        #13..17
        */
        //end;


        //Unsupported feature: Code Modification on ""TCS Nature of Collection"(Field 16502).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetSalesHeader;
        IF TCSNOC.GET("TCS Nature of Collection") THEN
          "TCS Type" := TCSNOC."TCS Type"
        ELSE
          "TCS Type" := "TCS Type"::" ";
        IF GSTManagement.CheckGSTStrucure(SalesHeader.Structure) THEN BEGIN
          SalesHeader.TESTFIELD("Applies-to Doc. No.",'');
          SalesHeader.TESTFIELD("Applies-to ID",'');
        END;
        IF SalesHeader."Applies-to Doc. No." <> '' THEN
          SalesHeader.TESTFIELD("Applies-to Doc. No.",'');
        IF (SalesHeader."Applies-to ID" <> '') AND ("TCS Nature of Collection" <> xRec."TCS Nature of Collection") THEN
          SalesHeader.TESTFIELD("Applies-to ID",'');
        IF "TCS Nature of Collection" <> '' THEN BEGIN
          NOCLine.RESET;
          NOCLine.SETRANGE(Type,NODLines.Type::Customer);
          NOCLine.SETRANGE("No.","Bill-to Customer No.");
          NOCLine.SETRANGE("NOD/NOC","TCS Nature of Collection");
          IF NOT NOCLine.FINDFIRST THEN
            ERROR(NOCNotFoundErr,"TCS Nature of Collection","Bill-to Customer No.");
          TCSNatureOfCollection.GET("TCS Nature of Collection");
          IF TCSNatureOfCollection."TCS on Recpt. Of Pmt." THEN
            ERROR(TCSNatureOfCollection2Err,"Document No.","Line No.");
        END;
        InitTCS(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..16
          NOCLine.SETRANGE("No.","Sell-to Customer No.");
          NOCLine.SETRANGE("NOD/NOC","TCS Nature of Collection");
          IF NOT NOCLine.FINDFIRST THEN
            ERROR(NOCNotFoundErr,"TCS Nature of Collection","Sell-to Customer No.");
        END;
        InitTCS(Rec);
        */
        //end;
        field(50000; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Doctor,Nurse,Ambulence';
            OptionMembers = " ",Doctor,Nurse,Ambulence;
        }
        field(50001; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // IF "Contract Start Date" <> 0D THEN
                //COntractDays
                // ELSE
                //  "No of Days" := 0;
                // "No of Days" := "Contract End Date" - "Contract Start Date"
            end;
        }
        field(50002; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // IF "Contract End Date" <> 0D THEN
                //COntractDays
                // ELSE
                //  "No of Days" := 0;
                // "No of Days" := "Contract End Date" - "Contract Start Date"
            end;
        }
        field(50003; "No of Days"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                Resourse: Record Resource;
            begin
                //IF ("Contract End Date" <> 0D) AND ("Contract Start Date" <> 0D) THEN
                //COntractDays;
                //"No of Days" := "Contract End Date" - "Contract Start Date"
                //VALIDATE(Quantity,"No of Days");
                /* IF "Document Type" = "Document Type"::Quote THEN
                     IF "No of Days" <> 0 THEN
                         "Line Amount" := "No of Days" * Quantity * "Unit Price";*/

                IF "No of Days" <> 0 THEN begin
                    "Service Amount" := "No of Days" * "Service Unit Price";
                    if "Service Unit Price" <> 0 then
                        Validate("Unit Price", "No of Days" * "Service Unit Price");
                end ELSE
                    "Service Amount" := 0;
                if "Document Type" = "Document Type"::Quote then begin
                    Resourse.Reset();
                    Resourse.SetRange("No.", "No.");
                    if Resourse.FindFirst() then begin
                        if "No of Days" <> 0 then begin
                            Validate("Unit Cost", "No of Days" * Resourse."Unit Cost");
                            Validate("Unit Cost (LCY)", "No of Days" * Resourse."Unit Cost");
                        end;
                    end;
                end;
            end;
        }
        field(50004; "Service Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Document Type" = "Document Type"::Quote then begin
                    IF "Service Unit Price" <> 0 THEN begin
                        "Service Amount" := "No of Days" * "Service Unit Price";
                        Validate("Unit Price", "No of Days" * "Service Unit Price");
                    end ELSE begin
                        "Service Amount" := 0;
                        "Unit Price" := 0;
                    end;
                end;

                //VALIDATE("Unit Price","Service Unit Price");
            end;
        }
        field(50005; "Service Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50006; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Activity";

            trigger OnValidate()
            begin
                IF JobActivity.GET("Activity Code") THEN
                    "Activity Description" := JobActivity."Activity Description"
                ELSE
                    "Activity Description" := '';
            end;
        }
        field(50007; "Activity Description"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Per Day Working Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "No. Of Cycle"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    //Unsupported feature: Variable Insertion (Variable: SurchargeBaseAmount) (VariableCollection) on "CalculateTCS(PROCEDURE 1500010)".


    //Unsupported feature: Variable Insertion (Variable: QtyFactor) (VariableCollection) on "CalculateTCS(PROCEDURE 1500010)".



    //Unsupported feature: Code Modification on "CalculateTCS(PROCEDURE 1500010)".

    //procedure CalculateTCS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF SalesHeader."Assessee Code" = '' THEN
      EXIT;
    "Per Contract" := FALSE;
    Customer.GET(SalesHeader."Bill-to Customer No.");
    WITH SalesLine DO BEGIN
      SETRANGE("Document Type",SalesHeader."Document Type");
      SETRANGE("Document No.",SalesHeader."No.");
      SETFILTER(Type,'%1|%2|%3',Type::"G/L Account",Type::Item,Type::"Charge (Item)");
      IF FIND('-') THEN
        REPEAT
          IF ("TCS Nature of Collection" <> '') AND (AccPeriodFilter = '') THEN
            DateFilterCalc.CreateTCSAccountingDateFilter(AccPeriodFilter,FiscalYear,SalesHeader."Posting Date",0);
          InitTCS(SalesLine);
          TCSBuffer[1].DELETEALL;
          "Per Contract" := FALSE;
          TCSAmount := 0;
          SurchargeAmount := 0;
          OrderAmount := 0;
          OrderTCSAmount := 0;
          AppliedAmount := 0;
          CLEAR(CustLedgEntry);
          NOCLine.RESET;
          NOCLine.SETRANGE(Type,NOCLine.Type::Customer);
          NOCLine.SETRANGE("No.","Bill-to Customer No.");
          NOCLine.SETRANGE("NOD/NOC","TCS Nature of Collection");
          IF NOCLine.FINDFIRST THEN BEGIN
            "Concessional Code" := NOCLine."Concessional Code";
            TCSSetup.RESET;
            TCSSetup.SETRANGE("TCS Nature of Collection","TCS Nature of Collection");
            TCSSetup.SETRANGE("Assessee Code","Assessee Code");
            TCSSetup.SETRANGE("TCS Type","TCS Type");
            TCSSetup.SETRANGE("Effective Date",0D,SalesHeader."Posting Date");
            TCSSetup.SETRANGE("Concessional Code",NOCLine."Concessional Code");

            IF TCSSetup.FINDLAST THEN BEGIN
              StructOrderLine.RESET;
              StructOrderLine.SETCURRENTKEY(Type,"Document Type","Document No.","Item No.","Line No.");
              StructOrderLine.SETRANGE(Type,StructOrderLine.Type::Sale);
              StructOrderLine.SETRANGE("Document Type","Document Type");
              StructOrderLine.SETRANGE("Document No.","Document No.");
              StructOrderLine.SETRANGE("Item No.","No.");
              StructOrderLine.SETRANGE("Line No.","Line No.");
              StructOrderLine.CALCSUMS("Amount (LCY)",Amount);
              UpdateTCSBaseLCY(SalesHeader,SalesLine,StructOrderLine);
              CalculateTCSPreviousAmounts(SalesLine,AccPeriodFilter,InvoiceAmount,PrevTCSAmount,PrevSurchargeAmount);
              PrevInvoiceAmount := InvoiceAmount;
              PrevContractAmount := CalculateTCSPreviousContractAmt(SalesLine,AccPeriodFilter);
              OrderTCSCalc := FALSE;
              SalesLine2.RESET;
              SalesLine2.SETRANGE("Document Type","Document Type");
              SalesLine2.SETRANGE("Document No.","Document No.");
              SalesLine2.SETRANGE("TCS Type","TCS Type");
              SalesLine2.SETRANGE("TCS Nature of Collection","TCS Nature of Collection");
              SalesLine2.SETRANGE("Assessee Code","Assessee Code");
              SalesLine2.SETFILTER("Line No.",'<%1',"Line No.");
              SalesLine2.SETFILTER(
                Type,'%1|%2|%3',SalesLine2.Type::"G/L Account",SalesLine2.Type::Item,SalesLine2.Type::"Charge (Item)");
              SetQtyTypeFilter(SalesLine2);
              IF SalesLine2.FIND('-') THEN
                REPEAT
                  TotalGSTAmount := 0;
                  IF GSTManagement.IsGSTApplicable(SalesHeader.Structure) AND NOT StructOrderLine.DoesTCSBaseExcludeGST(SalesHeader)
                  THEN
                    TotalGSTAmount := SalesLine2."Total GST Amount";
                  OrderAmount := CalculateOrderAmount(SalesLine2,TotalGSTAmount,Currency."Amount Rounding Precision");
                  OrderTCSAmount := OrderTCSAmount + SalesLine2."Total TDS/TCS Incl. SHE CESS";
                  IF NOT OrderTCSCalc THEN
                    IF ((SalesLine2."TDS/TCS Base Amount" <> 0) AND (SalesLine2."TDS/TCS %" <> 0)) OR (OrderTCSAmount <> 0) THEN
                      OrderTCSCalc := TRUE;
                  IF "Per Contract" THEN BEGIN
                    ContractAmount := ContractAmount + SalesLine2."TDS/TCS Base Amount";
                    ContractTCSAmount := ContractTCSAmount + SalesLine2."Total TDS/TCS Incl. SHE CESS";
                  END;
                UNTIL SalesLine2.NEXT = 0;
              IF "Currency Code" <> '' THEN
                OrderAmount := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      SalesHeader."Posting Date","Currency Code",
                      OrderAmount,SalesHeader."Currency Factor"));

              InsertBuffer := FALSE;
              CalcTCS := FALSE;

              "Surcharge Base Amount" := TCSBaseLCY;
              "TDS/TCS %" := SetTDSTCSPernt(TCSSetup,Customer);
              "Surcharge %" := TCSSetup."Surcharge %";
              "eCESS % on TDS/TCS" := TCSSetup."eCESS %";
              "SHE Cess % on TDS/TCS" := TCSSetup."SHE Cess %";
              "Sales Amount" := TCSBaseLCY;
              IF (SalesHeader."Applies-to Doc. No." = '') AND (SalesHeader."Applies-to ID" = '') THEN
                IF NOCLine."Threshold Overlook" THEN BEGIN
                  "TDS/TCS Base Amount" := TCSBaseLCY;
                  CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
                    PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);
                END ELSE
                  IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."TCS Threshold Amount" THEN BEGIN
                    "TDS/TCS Base Amount" := TCSBaseLCY - ContractAmount;
                    CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
                      PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);
                  END ELSE
                    IF ((PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."TCS Threshold Amount") AND
                       (TCSSetup."Contract Amount" <> 0)
                    THEN BEGIN
                      IF TCSSetup."Calc. Over & Above Threshold" THEN
                        "TDS/TCS Base Amount" := (PrevInvoiceAmount + TCSBaseLCY) - PrevContractAmount +
                          OrderAmount - ContractAmount - TCSSetup."TCS Threshold Amount"
                      ELSE
                        "TDS/TCS Base Amount" := PrevInvoiceAmount + TCSBaseLCY - PrevContractAmount + OrderAmount - ContractAmount;

                      "Sales Amount" := TCSBaseLCY + OrderAmount;
                      ClearPrevSaleTDSBaseLines(SalesLine);
                      IF NOCLine."Surcharge Overlook" THEN
                        "Surcharge Base Amount" += (PrevInvoiceAmount - PrevContractAmount + OrderAmount - ContractAmount)
                      ELSE
                        IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount" THEN
                          "Surcharge Base Amount" += PrevInvoiceAmount - PrevContractAmount + OrderAmount
                        ELSE
                          IF NOT ((PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount") THEN
                            "Surcharge %" := 0;

                      InsertBuffer := TRUE;
                      CalcTCS := TRUE;
                    END ELSE
                      IF ((TCSBaseLCY + OrderAmount) > TCSSetup."Contract Amount") AND
                         (TCSSetup."Contract Amount" <> 0)
                      THEN BEGIN
                        "Per Contract" := TRUE;
                        IF OrderTCSAmount = 0 THEN
                          "TDS/TCS Base Amount" := TCSBaseLCY + OrderAmount - ContractAmount
                        ELSE
                          "TDS/TCS Base Amount" := TCSBaseLCY;
                        IF NOCLine."Surcharge Overlook" THEN
                          "Surcharge Base Amount" := ABS("Surcharge Base Amount" + OrderAmount - ContractAmount)
                        ELSE
                          IF NOT (TCSBaseLCY > TCSSetup."Surcharge Threshold Amount") THEN
                            "Surcharge %" := 0;
                      END ELSE
                        IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY ) > TCSSetup."TCS Threshold Amount" THEN BEGIN
                          CalcTCSOverAboveThreshold(SalesLine,TCSSetup,PrevInvoiceAmount,OrderAmount);
                          ClearPrevSaleTDSBaseLines(SalesLine);
                          CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
                            PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);
                          InsertBuffer := TRUE;
                          CalcTCS := TRUE;
                        END ELSE BEGIN
                          "TDS/TCS Base Amount" := TCSBaseLCY;
                          "TDS/TCS %" := 0;
                          "eCESS % on TDS/TCS" := 0;
                          "SHE Cess % on TDS/TCS" := 0;
                          "Surcharge %" := 0;
                          "Surcharge Amount" := 0;
                          "TDS/TCS Amount" := 0;
                        END
              ELSE
                IF "Document Type" IN ["Document Type"::"Credit Memo","Document Type"::"Return Order"] THEN BEGIN
                  TCSEntry.RESET;
                  TCSEntry.SETCURRENTKEY("Document No.","Posting Date");
                  IF SalesHeader."Applies-to Doc. No." <> '' THEN
                    TCSEntry.SETRANGE("Document No.",SalesHeader."Applies-to Doc. No.")
                  ELSE BEGIN
                    CustLedgEntry.RESET;
                    CustLedgEntry.SETRANGE("Applies-to ID",SalesHeader."Applies-to ID");
                    CustLedgEntry.SETRANGE("TCS Nature of Collection","TCS Nature of Collection");
                    CustLedgEntry.SETRANGE("TCS Type","TCS Type");
                    IF CustLedgEntry.FINDFIRST THEN
                      TCSEntry.SETRANGE("Document No.",CustLedgEntry."Document No.")
                  END;
                  IF TCSEntry.FIND('+') THEN
                    IF NOT TCSEntry."TCS Paid" THEN BEGIN
                      "TDS/TCS Base Amount" := TCSBaseLCY;
                      "TDS/TCS %" := TCSEntry."TCS %";
                      "eCESS % on TDS/TCS" := TCSEntry."eCESS %";
                      "SHE Cess % on TDS/TCS" := TCSEntry."SHE Cess %";
                      "Surcharge %" := TCSEntry."Surcharge %";
                      "Surcharge Amount" := TCSEntry."Surcharge Amount";
                      "TDS/TCS Amount" := TCSEntry."TCS Amount";
                    END ELSE BEGIN
                      "TDS/TCS Base Amount" := TCSBaseLCY;
                      "TDS/TCS %" := 0;
                      "eCESS % on TDS/TCS" := 0;
                      "SHE Cess % on TDS/TCS" := 0;
                      "Surcharge %" := 0;
                      "Surcharge Amount" := 0;
                      "TDS/TCS Amount" := 0;
                    END;
                END ELSE BEGIN
                  CalculateTCSAppliedAmt(SalesHeader,SalesLine,AppliedAmount);
                  IF AppliedAmount <> 0 THEN BEGIN
                    IF (TCSBaseLCY + OrderAmount) >= ABS(AppliedAmount) THEN BEGIN
                      CompareAppliedAmtWithThershold(SalesLine,TCSSetup,NOCLine,ABS(AppliedAmount),OrderAmount,OrderTCSAmount,
                        PrevInvoiceAmount,PrevSurchargeAmount,
                        InsertBuffer,ContractAmount,PrevContractAmount,CalcTCS,OrderTCSCalc);
                      "Temp TDS/TCS Base" := TCSBaseLCY - ABS(AppliedAmount);
                    END ELSE BEGIN
                      "TDS/TCS Base Amount" := 0;
                      "Sales Amount" := 0;
                      "TDS/TCS %" := 0;
                      "eCESS % on TDS/TCS" := 0;
                      "SHE Cess % on TDS/TCS" := 0;
                      "Surcharge %" := 0;
                    END;
                  END ELSE
                    CalcBlankTCSAppliedAmt(SalesLine,NOCLine,TCSSetup,PrevInvoiceAmount,OrderAmount,OrderTCSAmount,
                      PrevSurchargeAmount,ContractAmount,PrevContractAmount,InsertBuffer,CalcTCS);
                END;
              IF InsertBuffer THEN BEGIN
                Rec := SalesLine;
                InsertGenTCSBuffer(FALSE);
                TCSEntry.RESET;
                TCSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TCS Type","Assessee Code",Applied);
                TCSEntry.SETRANGE("Party Type",TCSEntry."Party Type"::Customer);
                IF (Customer."P.A.N. No." = '') AND (Customer."P.A.N. Status" <> Customer."P.A.N. Status"::" ") THEN
                  TCSEntry.SETRANGE("Party Code","Bill-to Customer No.")
                ELSE
                  TCSEntry.SETRANGE("Party P.A.N. No.",Customer."P.A.N. No.");
                TCSEntry.SETFILTER("Posting Date",AccPeriodFilter);
                TCSEntry.SETRANGE("TCS Type","TCS Type");
                TCSEntry.SETRANGE("Assessee Code","Assessee Code");
                TCSEntry.SETRANGE(Applied,FALSE);
                IF TCSEntry.FIND('-') THEN
                  REPEAT
                    InsertTCSBuffer(TCSEntry,SalesHeader."Posting Date","Surcharge %" <> 0,FALSE);
                  UNTIL TCSEntry.NEXT = 0;
              END;

              IF TCSBaseLCY <> 0 THEN BEGIN
                IF TCSBuffer[1].FIND('+') THEN BEGIN
                  REPEAT
                    TCSAmount :=
                      TCSAmount + (TCSBuffer[1]."TCS Base Amount" - TCSBuffer[1]."Contract TCS Ded. Base Amount") *
                      TCSBuffer[1]."TCS %" / 100;

                  UNTIL TCSBuffer[1].NEXT(-1) = 0;
                  IF TCSBaseLCY < 0 THEN
                    "TDS/TCS Amount" := -RoundTCSAmount(TCSAmount)
                  ELSE
                    "TDS/TCS Amount" := RoundTCSAmount(TCSAmount);

                  IF "TDS/TCS Base Amount" <> 0 THEN
                    "TDS/TCS %" := ABS(ROUND(TCSAmount * 100 / "TDS/TCS Base Amount",0.001));
                END ELSE
                  "TDS/TCS Amount" := RoundTCSAmount("TDS/TCS %" * "TDS/TCS Base Amount" / 100);

                "eCESS on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amount" * "eCESS % on TDS/TCS" / 100);
                "SHE Cess on TDS/TCS Amount" := RoundTCSAmount("TDS/TCS Amount" * "SHE Cess % on TDS/TCS" / 100);
                SurchargeAmount := "TDS/TCS Amount" + "eCESS on TDS/TCS Amount" + "SHE Cess on TDS/TCS Amount";
                "Surcharge Amount" := RoundTCSAmount(SurchargeAmount * "Surcharge %" / 100);
                IF TCSBaseLCY < 0 THEN
                  "Surcharge Amount" := -RoundTCSAmount("Surcharge Amount")
                ELSE
                  "Surcharge Amount" := RoundTCSAmount("Surcharge Amount");
                "Total TDS/TCS Incl. SHE CESS" := "TDS/TCS Amount" + "Surcharge Amount" + "eCESS on TDS/TCS Amount" +
                  "SHE Cess on TDS/TCS Amount";
                "Bal. TDS/TCS Including SHECESS" := "Total TDS/TCS Incl. SHE CESS";
                IF "Currency Code" <> '' THEN
                  UpdateAmountBasedOnCurrency(SalesLine,SalesHeader."Currency Factor");
              END;
            END;
          END;
          MODIFY;
        UNTIL NEXT = 0;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    Customer.GET(SalesHeader."Sell-to Customer No.");

    #5..21
          IF GSTManagement.IsGSTApplicable(SalesHeader.Structure) AND (SalesHeader."Applies-to Doc. No." <> '') THEN
            CheckTCSwithGSTValidation(SalesHeader);

          NOCLine.RESET;
          NOCLine.SETRANGE(Type,NOCLine.Type::Customer);
          NOCLine.SETRANGE("No.","Sell-to Customer No.");
    #25..57
              IF "Document Type" = "Document Type"::Order THEN
                SalesLine2.SETFILTER("Qty. to Invoice",'<>%1',0);
    #59..61
                  IF (GSTManagement.IsGSTApplicable(SalesHeader.Structure) AND
                      (NOT SalesLine2."Price Inclusive of Tax")) THEN
                    TotalGSTAmount := SalesLine2."Total GST Amount";
                  IF Quantity <> "Qty. to Invoice" THEN BEGIN
                    QtyFactor := "Qty. to Invoice" / Quantity;
                    OrderAmount += ROUND((SalesLine2."Line Amount" - SalesLine2."Inv. Discount Amount" +
                                          SalesLine2."Service Tax Amount" + SalesLine2."Service Tax eCess Amount" +
                                          SalesLine2."Service Tax SHE Cess Amount" + SalesLine2."Service Tax SBC Amount" +
                                          SalesLine2."KK Cess Amount" + TotalGSTAmount) *
                        QtyFactor,Currency."Amount Rounding Precision");
                  END ELSE
                    OrderAmount += SalesLine2."Line Amount" - SalesLine2."Inv. Discount Amount" +
                      SalesLine2."Service Tax Amount" + SalesLine2."Service Tax eCess Amount" +
                      SalesLine2."Service Tax SHE Cess Amount" + SalesLine2."Service Tax SBC Amount" +
                      SalesLine2."KK Cess Amount" + TotalGSTAmount;
    #66..92
                  IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
                    PrevSurchargeAmount := 0
                  ELSE
                    IF (NOT NOCLine."Surcharge Overlook") AND
                       ((PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount")
                    THEN BEGIN
                      "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
                      InsertBuffer := TRUE;
                    END ELSE
                      IF NOT NOCLine."Surcharge Overlook" THEN
                        "Surcharge %" := 0;
    #95..97
                    IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
                      PrevSurchargeAmount := 0;
                    END ELSE
                      IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
                        "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
                        InsertBuffer := TRUE;
                      END ELSE
                        IF NOT NOCLine."Surcharge Overlook" THEN
                          "Surcharge %" := 0;
    #100..140
                          IF NOCLine."Surcharge Overlook" THEN
                            "Surcharge Base Amount" := ABS(PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount")
                          ELSE
                            IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
                              PrevSurchargeAmount := 0;
                            END ELSE
                              IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount" THEN
                                "Surcharge Base Amount" := PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount"
                              ELSE
                                "Surcharge %" := 0;

    #143..211
                TCSEntry.SETRANGE("Party Code","Sell-to Customer No.");
    #216..231
                    SurchargeBaseAmount := SurchargeBaseAmount + (TCSBuffer[1]."TCS %" *
                                                                  (TCSBuffer[1]."Surcharge Base Amount" -
                                                                   TCSBuffer[1]."Contract TCS Ded. Base Amount") / 100);
                    SurchargeAmount := SurchargeAmount + (TCSBuffer[1]."TCS %" *
                                                          (TCSBuffer[1]."Surcharge Base Amount" -
                                                           TCSBuffer[1]."Contract TCS Ded. Base Amount") / 100) *
                      (TCSBuffer[1]."Surcharge %" / 100);
                  UNTIL TCSBuffer[1].NEXT(-1) = 0;

                  IF TCSBaseLCY < 0 THEN BEGIN
                    "TDS/TCS Amount" := -RoundTCSAmount(TCSAmount);
                    "Surcharge Amount" := -RoundTCSAmount(SurchargeAmount);
                  END ELSE BEGIN
                    "TDS/TCS Amount" := RoundTCSAmount(TCSAmount);
                    "Surcharge Amount" := RoundTCSAmount(SurchargeAmount);
                  END;
    #238..240
                  IF SurchargeBaseAmount <> 0 THEN
                    "Surcharge %" := ABS(ROUND(SurchargeAmount * 100 / SurchargeBaseAmount));
                END ELSE BEGIN
                  "TDS/TCS Amount" := RoundTCSAmount("TDS/TCS %" * "TDS/TCS Base Amount" / 100);
                  "Surcharge Amount" := RoundTCSAmount(("TDS/TCS %" * "Surcharge Base Amount" / 100) * ("Surcharge %" / 100));
                END;

                "eCESS on TDS/TCS Amount" := RoundTCSAmount(("TDS/TCS Amount" + "Surcharge Amount") * "eCESS % on TDS/TCS" / 100);
                "SHE Cess on TDS/TCS Amount" :=
                  RoundTCSAmount(("TDS/TCS Amount" + "Surcharge Amount") * "SHE Cess % on TDS/TCS" / 100
                    );
    #252..262
    */
    //end;


    //Unsupported feature: Code Modification on "InsertGenTCSBuffer(PROCEDURE 1500006)".

    //procedure InsertGenTCSBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(TCSBuffer[1]);
    TCSBuffer[1]."TCS Nature of Collection" := "TCS Nature of Collection";
    TCSBuffer[1]."Assessee Code" := "Assessee Code";
    TCSBuffer[1]."Party Code" := "Bill-to Customer No.";
    TCSBuffer[1]."Party Type" := TCSBuffer[1]."Party Type"::Customer;
    IF Applied THEN BEGIN
      TCSBuffer[1]."TCS Base Amount" := ABS("Temp TDS/TCS Base");
    #8..13
    TCSBuffer[1]."TCS %" := "TDS/TCS %";
    TCSBuffer[1]."Surcharge %" := "Surcharge %";
    UpdateTCSBuffer;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    TCSBuffer[1]."Party Code" := "Sell-to Customer No.";
    #5..16
    */
    //end;


    //Unsupported feature: Code Modification on "InitTCS(PROCEDURE 1500005)".

    //procedure InitTCS();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
      "TDS/TCS Base Amount" := 0;
      "Sales Amount" := 0;
    #4..9
      "eCESS on TDS/TCS Amount" := 0;
      "SHE Cess on TDS/TCS Amount" := 0;
      "Total TDS/TCS Incl. SHE CESS" := 0;
      "Bal. TDS/TCS Including SHECESS" := 0;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
      {"Tot TDS/TCS Incl. SHECESS(LCY)" := 0;
      "TDS/TCS Amount (LCY)" := 0;
      "Surcharge Amount (LCY)" := 0;
      "TDS/TCS Incl. Surcharge (LCY)" := 0;
      "eCESS on TDS/TCS Amount (LCY)" := 0;
      "SHE Cess on TDS/TCS Amt (LCY)" := 0; }
      "Bal. TDS/TCS Including SHECESS" := 0;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateAmountBasedOnCurrency(PROCEDURE 1500049)".

    //procedure UpdateAmountBasedOnCurrency();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesLine."TDS/TCS Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."TDS/TCS Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."Surcharge Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."Surcharge Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."eCESS on TDS/TCS Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."eCESS on TDS/TCS Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."SHE Cess on TDS/TCS Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."SHE Cess on TDS/TCS Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."Total TDS/TCS Incl. SHE CESS" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."Total TDS/TCS Incl. SHE CESS",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."Bal. TDS/TCS Including SHECESS" := SalesLine."Total TDS/TCS Incl. SHE CESS";
    SalesLine."TDS/TCS Base Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."TDS/TCS Base Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."Surcharge Base Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."Surcharge Base Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    SalesLine."Sales Amount" :=
      ROUND(
        CurrExchRate.ExchangeAmtLCYToFCY(
          SalesHeader."Posting Date",SalesLine."Currency Code",
          SalesLine."Sales Amount",CurrencyFactor),
        Currency."Amount Rounding Precision");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..31
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateTCSBaseLCY(PROCEDURE 1500057)".

    //procedure UpdateTCSBaseLCY();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
      IF QtyType = QtyType::General THEN BEGIN
        LineAmtQtytoInv := "Line Amount";
        InvDiscQtytoInv := "Inv. Discount Amount";
        StruAmt := StructureOrderLineDetails.Amount;
        StruAmtLCY := StructureOrderLineDetails."Amount (LCY)";
        TotalGSTAmt := "Total GST Amount";
      END ELSE BEGIN
        IF QtyType = QtyType::Shipping THEN BEGIN
          IF "Document Type" = "Document Type"::"Return Order" THEN
            QtyFactor := "Return Qty. to Receive" / Quantity
          ELSE
            QtyFactor := "Qty. to Ship" / Quantity;
        END ELSE
          IF QtyType = QtyType::Invoicing THEN
            QtyFactor := "Qty. to Invoice" / Quantity;
        LineAmtQtytoInv := ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
        InvDiscQtytoInv := ROUND("Inv. Discount Amount" * QtyFactor,Currency."Amount Rounding Precision");
        StruAmt := ROUND(StructureOrderLineDetails.Amount * QtyFactor,Currency."Amount Rounding Precision");
        StruAmtLCY := ROUND(StructureOrderLineDetails."Amount (LCY)" * QtyFactor,Currency."Amount Rounding Precision");
        TotalGSTAmt := ROUND("Total GST Amount" * QtyFactor,Currency."Amount Rounding Precision");
      END;
      IF (GSTManagement.IsGSTApplicable(SalesHeader.Structure) AND ("Currency Code" <> ''))
      THEN BEGIN
        IF NOT StructureOrderLineDetails.DoesTCSBaseExcludeGST(SalesHeader) THEN
          TCSBaseLCY := LineAmtQtytoInv - InvDiscQtytoInv + StruAmt
        ELSE
          TCSBaseLCY := LineAmtQtytoInv - InvDiscQtytoInv;
      END ELSE
        IF NOT StructureOrderLineDetails.DoesTCSBaseExcludeGST(SalesHeader) THEN
          TCSBaseLCY := LineAmtQtytoInv - InvDiscQtytoInv + StruAmtLCY
        ELSE
          TCSBaseLCY := LineAmtQtytoInv - InvDiscQtytoInv;
      IF "GST On Assessable Value" AND NOT StructureOrderLineDetails.DoesTCSBaseExcludeGST(SalesHeader) THEN BEGIN
        LineAmt :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              SalesHeader."Posting Date","Currency Code",LineAmtQtytoInv,SalesHeader."Currency Factor"));
        InvDiscAmt :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              SalesHeader."Posting Date","Currency Code",InvDiscQtytoInv,SalesHeader."Currency Factor"));
        TCSBaseLCY := LineAmt - InvDiscAmt + TotalGSTAmt;
      END;
      IF ("Currency Code" <> '') AND
         (NOT "GST On Assessable Value" OR StructureOrderLineDetails.DoesTCSBaseExcludeGST(SalesHeader))
      THEN
        TCSBaseLCY :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              SalesHeader."Posting Date","Currency Code",ABS(TCSBaseLCY),SalesHeader."Currency Factor"));
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
      IF "Qty. to Invoice" <> Quantity THEN BEGIN
        QtyFactor := "Qty. to Invoice" / Quantity;
    #17..21
      END ELSE BEGIN
    #3..7
      END;

      IF (GSTManagement.IsGSTApplicable(SalesHeader.Structure) AND (NOT SalesLine2."Price Inclusive of Tax") AND
          ("Currency Code" <> ''))
    #24..52
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateTCSPreviousAmounts(PROCEDURE 1170000005)".

    //procedure CalculateTCSPreviousAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
      Customer.GET("Bill-to Customer No.");
      IF (Customer."P.A.N. No." = '') AND (Customer."P.A.N. Status" = Customer."P.A.N. Status"::" ") THEN
        ERROR(PANErr,Customer."No.");
      CLEAR(TCSPrevInvoiceAmount);
      CLEAR(TCSPrevAmount);
      CLEAR(TCSPrevSurchargeAmount);
      TCSEntry.RESET;
      TCSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TCS Type","Assessee Code","Document Type");
      TCSEntry.SETRANGE("Party Type",TCSEntry."Party Type"::Customer);
      IF Customer."P.A.N. Status" <> Customer."P.A.N. Status"::" " THEN
        TCSEntry.SETRANGE("Party Code","Bill-to Customer No.")
      ELSE
        TCSEntry.SETRANGE("Party P.A.N. No.",Customer."P.A.N. No.");
      TCSEntry.SETFILTER("Posting Date",AccPeriodFilter);
      TCSEntry.SETRANGE("TCS Type","TCS Type");
      TCSEntry.SETRANGE("Assessee Code","Assessee Code");
    #18..23
      TCSPrevAmount := ABS(TCSEntry."TCS Amount");
      TCSPrevSurchargeAmount := ABS(TCSEntry."Surcharge Amount");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
    #5..10
      TCSEntry.SETRANGE("Party Code","Sell-to Customer No.");
    #15..26
    */
    //end;


    //Unsupported feature: Code Modification on "CalculateTCSPreviousContractAmt(PROCEDURE 1170000002)".

    //procedure CalculateTCSPreviousContractAmt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
      Customer.GET("Bill-to Customer No.");
      TCSEntry.RESET;
      TCSEntry.SETCURRENTKEY("Party Type","Party Code","Posting Date","TCS Type","Assessee Code",Applied,"Per Contract");
      TCSEntry.SETRANGE("Party Type",TCSEntry."Party Type"::Customer);
      IF Customer."P.A.N. Status" <> Customer."P.A.N. Status"::" " THEN
        TCSEntry.SETRANGE("Party Code","Bill-to Customer No.")
      ELSE
        TCSEntry.SETRANGE("Party P.A.N. No.",Customer."P.A.N. No.");
      TCSEntry.SETFILTER("Posting Date",AccPeriodFilter);
      TCSEntry.SETRANGE("TCS Type","TCS Type");
      TCSEntry.SETRANGE("Assessee Code","Assessee Code");
      TCSEntry.SETRANGE(Applied,FALSE);
      TCSEntry.SETRANGE("Per Contract",TRUE);
      TCSEntry.CALCSUMS("Sales Amount","Service Tax Including eCess");
      EXIT(ABS(TCSEntry."Sales Amount") + ABS(TCSEntry."Service Tax Including eCess"));
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WITH SalesLine DO BEGIN
    #3..5
      TCSEntry.SETRANGE("Party Code","Sell-to Customer No.");
    #10..17
    */
    //end;


    //Unsupported feature: Code Modification on "CalcBlankTCSAppliedAmt(PROCEDURE 1170000000)".

    //procedure CalcBlankTCSAppliedAmt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO
      IF NodNocLines."Threshold Overlook" THEN BEGIN
        "TDS/TCS Base Amount" := TCSBaseLCY;
        CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
          PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);
      END ELSE
        IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."TCS Threshold Amount" THEN BEGIN
          "TDS/TCS Base Amount" := TCSBaseLCY - ContractAmount;
          CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
            PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);
        END ELSE
          IF ((PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."TCS Threshold Amount") AND
             (TCSSetup."Contract Amount" <> 0)
    #14..52
                  "TDS/TCS Base Amount" := PrevInvoiceAmount + TCSBaseLCY + OrderAmount;
                "Sales Amount" := TCSBaseLCY + OrderAmount;
                ClearPrevSaleTDSBaseLines(SalesLine);
                CalcSurchargeOnTCS(SalesLine,TCSSetup."Surcharge Threshold Amount",PrevInvoiceAmount,OrderAmount,
                  PrevSurchargeAmount,NOCLine."Surcharge Overlook",InsertBuffer);

                InsertBuffer := TRUE;
                CalcTCS := TRUE;
    #61..66
                "Surcharge Amount" := 0;
                "TDS/TCS Amount" := 0;
              END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
        IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
          PrevSurchargeAmount := 0
        ELSE
          IF (NOT NodNocLines."Surcharge Overlook") AND
             ((PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount")
          THEN BEGIN
            "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
            InsertBuffer := TRUE;
          END ELSE
            IF NOT NodNocLines."Surcharge Overlook" THEN
              "Surcharge %" := 0;
    #6..8
          IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
            PrevSurchargeAmount := 0
          ELSE
            IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
              "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
              InsertBuffer := TRUE;
            END ELSE
              IF NOT NodNocLines."Surcharge Overlook" THEN
                "Surcharge %" := 0;
    #11..55

                IF NodNocLines."Surcharge Overlook" THEN
                  "Surcharge Base Amount" := ABS(PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount")
                ELSE
                  IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
                    PrevSurchargeAmount := 0
                  ELSE
                    IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY) > TCSSetup."Surcharge Threshold Amount" THEN
                      "Surcharge Base Amount" := PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount"
                    ELSE
                      "Surcharge %" := 0;
    #58..69
    */
    //end;


    //Unsupported feature: Code Modification on "CompareAppliedAmtWithThershold(PROCEDURE 1170000009)".

    //procedure CompareAppliedAmtWithThershold();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO
      IF NodNocLines."Threshold Overlook" THEN BEGIN
        IF (OrderTCSAmount = 0) AND (NOT OrderTCSCalc) THEN BEGIN
          "TDS/TCS Base Amount" := OrderAmount + TCSBaseLCY - AppliedTCSAmt;
          "Sales Amount" := OrderAmount + TCSBaseLCY - AppliedTCSAmt;
          SalesAmtOnAppliedDoc(SalesLine);
        END ELSE
          "TDS/TCS Base Amount" := TCSBaseLCY;
        IF NodNocLines."Surcharge Overlook" OR (TCSSetup."Surcharge Threshold Amount" = 0) THEN
          "Surcharge Base Amount" := "TDS/TCS Base Amount"
        ELSE
          CheckSurchargeOverlookHigherThreshold(SalesLine,NodNocLines,TCSSetup,
            PrevInvoiceAmount,OrderAmount,AppliedTCSAmt,PrevSurchargeAmount,InsertBuffer);
      END ELSE
        IF (PrevInvoiceAmount + OrderAmount - AppliedTCSAmt) > TCSSetup."TCS Threshold Amount" THEN BEGIN
          IF (OrderTCSAmount = 0) AND (NOT OrderTCSCalc) THEN BEGIN
    #17..35
              ClearPrevSaleTDSBaseLines(SalesLine);
            END ELSE
              "TDS/TCS Base Amount" := TCSBaseLCY;
            IF NodNocLines."Surcharge Overlook" THEN
              "Surcharge Base Amount" := TCSBaseLCY + OrderAmount - ContractAmount - AppliedTCSAmt
            ELSE
              IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount" THEN
                "Surcharge Base Amount" += PrevInvoiceAmount - PrevContractAmount + OrderAmount - AppliedTCSAmt
              ELSE
                IF NOT ((PrevInvoiceAmount + OrderAmount - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount") THEN
                  "Surcharge %" := 0;
            InsertBuffer := TRUE;
            CalcTCS := TRUE;
          END ELSE
    #50..57
              END ELSE
                "TDS/TCS Base Amount" := TCSBaseLCY;
              IF NodNocLines."Surcharge Overlook" THEN
                "Surcharge Base Amount" := ABS("Surcharge Base Amount" + OrderAmount - ContractAmount - AppliedTCSAmt)
              ELSE
                IF NOT (TCSBaseLCY > TCSSetup."Surcharge Threshold Amount") THEN
                  "Surcharge %" := 0;
    #65..73
                  ClearPrevSaleTDSBaseLines(SalesLine);
                END ELSE
                  "TDS/TCS Base Amount" := TCSBaseLCY;
                IF TCSSetup."Surcharge Threshold Amount" = 0 THEN
                  "Surcharge Base Amount" := "TDS/TCS Base Amount"
                ELSE
                  CheckSurchargeOverlookHigherThreshold(SalesLine,NodNocLines,TCSSetup,
                    PrevInvoiceAmount,OrderAmount,AppliedTCSAmt,PrevSurchargeAmount,InsertBuffer);
                InsertBuffer := TRUE;
                CalcTCS := TRUE;
              END ELSE
    #85..92
                    CheckSurchargeOverlookLowerThreshold(SalesLine,NodNocLines,TCSSetup,
                      PrevInvoiceAmount,OrderAmount,AppliedTCSAmt,PrevSurchargeAmount);
                  END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
        IF (NOT NodNocLines."Surcharge Overlook") AND
           ((PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount")
        THEN BEGIN
          "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
          InsertBuffer := TRUE;
        END ELSE
          IF NOT NodNocLines."Surcharge Overlook" THEN
            "Surcharge %" := 0;
    #14..38

            IF NodNocLines."Surcharge Overlook" THEN
              "Surcharge Base Amount" += PrevInvoiceAmount - PrevContractAmount + OrderAmount - ContractAmount - AppliedTCSAmt
            ELSE
              IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount" THEN
                "Surcharge Base Amount" += PrevInvoiceAmount - PrevContractAmount + OrderAmount
              ELSE
                IF NOT ((PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount") THEN
                  "Surcharge %" := 0;

    #47..60
                "Surcharge Base Amount" := ABS("Surcharge Base Amount" + OrderAmount - ContractAmount)
    #62..76

                IF NodNocLines."Surcharge Overlook" THEN
                  "Surcharge Base Amount" := ABS(PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount")
                ELSE
                  IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
                    PrevSurchargeAmount := 0
                  ELSE
                    IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount" THEN
                      "Surcharge Base Amount" := PrevInvoiceAmount + OrderAmount + "Surcharge Base Amount"
                    ELSE
                      "Surcharge %" := 0;

    #82..95
    */
    //end;


    //Unsupported feature: Code Modification on "CheckSurchargeOverlookHigherThreshold(PROCEDURE 1500074)".

    //procedure CheckSurchargeOverlookHigherThreshold();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH SalesLine DO
      IF NodNocLines."Surcharge Overlook" OR (TCSSetup."Surcharge Threshold Amount" = 0) THEN
        IF OrderAmount > AppliedTCSAmt THEN
          "Surcharge Base Amount" := TCSBaseLCY
        ELSE
          IF (OrderAmount + TCSBaseLCY) > AppliedTCSAmt THEN
            "Surcharge Base Amount" := OrderAmount + TCSBaseLCY - AppliedTCSAmt
          ELSE
            "Surcharge %" := 0
      ELSE
        IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
          PrevSurchargeAmount := 0
        ELSE
          IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
            "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount - AppliedTCSAmt;
            InsertBuffer := TRUE;
          END ELSE
            IF NOT NodNocLines."Surcharge Overlook" THEN
              "Surcharge %" := 0;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WITH SalesLine DO
      IF (PrevInvoiceAmount + OrderAmount) > TCSSetup."Surcharge Threshold Amount" THEN
        PrevSurchargeAmount := 0
      ELSE
        IF (PrevInvoiceAmount + OrderAmount + TCSBaseLCY - AppliedTCSAmt) > TCSSetup."Surcharge Threshold Amount" THEN BEGIN
          "Surcharge Base Amount" := "Surcharge Base Amount" + PrevInvoiceAmount + OrderAmount;
          InsertBuffer := TRUE;
        END ELSE
          IF NOT NodNocLines."Surcharge Overlook" THEN
            "Surcharge %" := 0;
    */
    //end;


    local procedure CheckTCSwithGSTValidation(SalesHeader: Record 36)
    var
        CustLedgerEntry: Record 21;
        SalesLine: Record 37;
    begin
        CustLedgerEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", "Document No.");
        CustLedgerEntry.SETRANGE("Customer No.", SalesHeader."Bill-to Customer No.");
        CustLedgerEntry.SETRANGE("Document No.", SalesHeader."Applies-to Doc. No.");
        CustLedgerEntry.SETFILTER("Amount to Apply", '<>%1', 0);
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");

            /* TEAM 14763
            IF CustLedgerEntry."TCS Nature of Collection" <> '' THEN
                SalesLine.SETRANGE("TCS Nature of Collection", CustLedgerEntry."TCS Nature of Collection");
            IF NOT SalesLine.FINDFIRST THEN
                SalesLine.TESTFIELD("TCS Nature of Collection");
            TEAM 14763 
            */
        END;
    end;

    local procedure COntractDays()
    begin
        "Contract Start Date" := 0D;
        "Contract End Date" := 0D;
        "No of Days" := 0;
        SalesHdr.RESET;
        SalesHdr.SETRANGE("No.", "Document No.");
        IF SalesHdr.FINDFIRST THEN BEGIN
            "Contract Start Date" := SalesHdr."Contract Start Date";
            "Contract End Date" := SalesHdr."Contract End Date";
            "No of Days" := SalesHdr."No of Days";
        END;

        IF ("Contract End Date" <> 0D) AND ("Contract Start Date" <> 0D) THEN
            "No of Days" := (("Contract End Date" - "Contract Start Date") DIV 30)
        ELSE
            "No of Days" := 0;

        VALIDATE(Quantity, "No of Days");
    end;

    var
        SalesHdr: Record 36;
        RSalesLine: Record 39;
        JobActivity: Record 50001;
}