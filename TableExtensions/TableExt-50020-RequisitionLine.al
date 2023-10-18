tableextension 50032 tableextension50032 extends "Requisition Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".


        //Unsupported feature: Property Modification (Data type) on ""Original Variant Code"(Field 5554)".


        //Unsupported feature: Deletion (FieldCollection) on ""Location Type"(Field 50003)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 9 Code"(Field 70020)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 10 Code"(Field 70021)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 11 Code"(Field 70022)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 12 Code"(Field 70023)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 13 Code"(Field 70024)".


        //Unsupported feature: Deletion (FieldCollection) on ""Shortcut Dimension 14 Code"(Field 70025)".


        //Unsupported feature: Code Modification on ""Replenishment System"(Field 99000903).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Type,Type::Item);
        CheckActionMessageNew;
        IF ValidateFields AND
           ("Replenishment System" = xRec."Replenishment System") AND
           ("No." = xRec."No.") AND
           ("Location Code" = xRec."Location Code") AND
           ("Variant Code" = xRec."Variant Code")
        THEN
          EXIT;

        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        GetItem;
        GetPlanningParameters.AtSKU(SKU,"No.","Variant Code","Location Code");
        IF Subcontracting THEN
          SKU."Replenishment System" := SKU."Replenishment System"::"Prod. Order";

        "Supply From" := '';

        CASE "Replenishment System" OF
          "Replenishment System"::Purchase:
            BEGIN
              "Ref. Order Type" := "Ref. Order Type"::Purchase;
              CLEAR("Ref. Order Status");
              "Ref. Order No." := '';
              DeleteRelations;
              VALIDATE("Production BOM No.",'');
              VALIDATE("Routing No.",'');
              IF Item."Purch. Unit of Measure" <> '' THEN
                VALIDATE("Unit of Measure Code",Item."Purch. Unit of Measure");
              VALIDATE("Transfer-from Code",'');
              IF CurrFieldNo = FIELDNO("Location Code") THEN
                VALIDATE("Vendor No.")
              ELSE
                VALIDATE("Vendor No.",SKU."Vendor No.");
            END;
          "Replenishment System"::"Prod. Order":
            BEGIN
              IF ReqWkshTmpl.GET("Worksheet Template Name") AND (ReqWkshTmpl.Type = ReqWkshTmpl.Type::"Req.") AND
                 (ReqWkshTmpl.Name <> '') AND NOT SourceDropShipment
              THEN
                ERROR(ReplenishmentErr);
              IF PlanningResiliency AND (Item."Base Unit of Measure" = '') THEN
                TempPlanningErrorLog.SetError(
                  STRSUBSTNO(
                    Text032,Item.TABLECAPTION,Item."No.",
                    Item.FIELDCAPTION("Base Unit of Measure")),
                  DATABASE::Item,Item.GETPOSITION);
              Item.TESTFIELD("Base Unit of Measure");
              IF "Ref. Order No." = '' THEN BEGIN
                "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
                "Ref. Order Status" := "Ref. Order Status"::Planned;

                MfgSetup.GET;
                IF PlanningResiliency AND (MfgSetup."Planned Order Nos." = '') THEN
                  TempPlanningErrorLog.SetError(
                    STRSUBSTNO(Text032,MfgSetup.TABLECAPTION,'',
                      MfgSetup.FIELDCAPTION("Planned Order Nos.")),
                    DATABASE::"Manufacturing Setup",MfgSetup.GETPOSITION);
                MfgSetup.TESTFIELD("Planned Order Nos.");

                IF PlanningResiliency THEN
                  CheckNoSeries(MfgSetup."Planned Order Nos.","Due Date");
                IF NOT Subcontracting THEN
                  NoSeriesMgt.InitSeries(
                    MfgSetup."Planned Order Nos.",xRec."No. Series","Due Date","Ref. Order No.","No. Series");
              END;
              VALIDATE("Vendor No.",'');

              IF NOT Subcontracting THEN BEGIN
                IF PlanningResiliency AND
                   ProdBOMHeader.GET(Item."Production BOM No.") AND
                   (ProdBOMHeader.Status <> ProdBOMHeader.Status::Certified)
                THEN BEGIN
                  TempPlanningErrorLog.SetError(
                    STRSUBSTNO(
                      Text033,ProdBOMHeader.TABLECAPTION,
                      ProdBOMHeader.FIELDCAPTION("No."),ProdBOMHeader."No."),
                    DATABASE::"Production BOM Header",ProdBOMHeader.GETPOSITION);
                  ProdBOMHeader.TESTFIELD(Status,ProdBOMHeader.Status::Certified);
                END;
                VALIDATE("Production BOM No.",Item."Production BOM No.");
                VALIDATE("Routing No.",Item."Routing No.");
              END ELSE BEGIN
                "Production BOM No." := Item."Production BOM No.";
                "Routing No." := Item."Routing No.";
              END;
              VALIDATE("Transfer-from Code",'');
              VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

              IF ("Planning Line Origin" = "Planning Line Origin"::"Order Planning") AND
                 ValidateFields
              THEN
                PlngLnMgt.Calculate(Rec,1,TRUE,TRUE,0);
            END;
          "Replenishment System"::Assembly:
            BEGIN
              IF PlanningResiliency AND (Item."Base Unit of Measure" = '') THEN
                TempPlanningErrorLog.SetError(
                  STRSUBSTNO(
                    Text032,Item.TABLECAPTION,Item."No.",
                    Item.FIELDCAPTION("Base Unit of Measure")),
                  DATABASE::Item,Item.GETPOSITION);
              Item.TESTFIELD("Base Unit of Measure");
              IF "Ref. Order No." = '' THEN BEGIN
                "Ref. Order Type" := "Ref. Order Type"::Assembly;
                "Ref. Order Status" := AsmHeader."Document Type"::Order;
              END;
              VALIDATE("Vendor No.",'');
              VALIDATE("Production BOM No.",'');
              VALIDATE("Routing No.",'');
              VALIDATE("Transfer-from Code",'');
              VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

              IF ("Planning Line Origin" = "Planning Line Origin"::"Order Planning") AND
                 ValidateFields
              THEN
                PlngLnMgt.Calculate(Rec,1,TRUE,TRUE,0);
            END;
          "Replenishment System"::Transfer:
            BEGIN
              "Ref. Order Type" := "Ref. Order Type"::Transfer;
              CLEAR("Ref. Order Status");
              "Ref. Order No." := '';
              DeleteRelations;
              VALIDATE("Vendor No.",'');
              VALIDATE("Production BOM No.",'');
              VALIDATE("Routing No.",'');
              VALIDATE("Transfer-from Code",SKU."Transfer-from Code");
              VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
            END;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..70
        #82..132
        */
        //end;
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF CURRENTKEY <> Rec2.CURRENTKEY THEN BEGIN
      Rec2 := Rec;
      Rec2.SETRECFILTER;
      Rec2.SETRANGE("Line No.");
      IF Rec2.FINDLAST THEN
        "Line No." := Rec2."Line No." + 10000;
    END;

    ReserveReqLine.VerifyQuantity(Rec,xRec);

    ReqWkshTmpl.GET("Worksheet Template Name");
    ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");

    ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
    ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");

    //*******************************************Custom For Dimension
    ValidateShortcutDimCode(9,"Shortcut Dimension 9 Code");
    ValidateShortcutDimCode(10,"Shortcut Dimension 10 Code");
    ValidateShortcutDimCode(11,"Shortcut Dimension 11 Code");
    ValidateShortcutDimCode(12,"Shortcut Dimension 12 Code");
    ValidateShortcutDimCode(13,"Shortcut Dimension 13 Code");
    ValidateShortcutDimCode(14,"Shortcut Dimension 14 Code");

    //*******************************************Custom For Dimension
    // 7287 code is left to add bcz of code diffrence in 2009
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..15
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateDescription(PROCEDURE 8)".

    //procedure UpdateDescription();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Type <> Type::Item) OR ("No." = '') THEN
      EXIT;
    IF "Variant Code" = '' THEN BEGIN
      GetItem;
      Description := Item.Description;
      "Description 2" := Item."Description 2";
    END ELSE BEGIN
      ItemVariant.GET("No.","Variant Code");
      Description := ItemVariant.Description;
      "Description 2" := ItemVariant."Description 2";
    END;

    IF SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.") THEN BEGIN
      Description := SalesLine.Description;
      "Description 2" := SalesLine."Description 2";
    END;

    IF "Vendor No." <> '' THEN
      IF ItemCrossRef.GetItemDescription(
           Description,"No.","Variant Code","Unit of Measure Code",ItemCrossRef."Cross-Reference Type"::Vendor,"Vendor No.")
      THEN
        "Description 2" := ''
      ELSE BEGIN
      Vend.GET("Vendor No.");
      IF Vend."Language Code" <> '' THEN
        IF ItemTranslation.GET("No.","Variant Code",Vend."Language Code") THEN BEGIN
          Description := ItemTranslation.Description;
          "Description 2" := ItemTranslation."Description 2";
        END;
    END;

    IF (CurrFieldNo <> 0) AND (CurrFieldNo <> FIELDNO("Location Code")) AND
       ("Planning Line Origin" = "Planning Line Origin"::" ")
    THEN
      IF "Vendor No." <> '' THEN BEGIN
        IF NOT IsDropShipment THEN
          "Location Code" := Vend."Location Code";
        IF ItemVend.GET("Vendor No.","No.","Variant Code") THEN
          IF ItemCrossRef.GET(
               "No.","Variant Code","Unit of Measure Code",
               ItemCrossRef."Cross-Reference Type"::Vendor,
               "Vendor No.",ItemVend."Vendor Item No.")
          THEN BEGIN
            Description := ItemCrossRef.Description;
            "Description 2" := '';
          END
      END ELSE
        "Location Code" := '';
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..23
        Vend.GET("Vendor No.");
        IF Vend."Language Code" <> '' THEN
          IF ItemTranslation.GET("No.","Variant Code",Vend."Language Code") THEN BEGIN
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
          END;
      END;
    #31..34
      IF ("Vendor No." <> '') AND NOT IsDropShipment THEN
        "Location Code" := Vend."Location Code"
      ELSE
        "Location Code" := '';
    */
    //end;


    //Unsupported feature: Code Modification on "CreateDim(PROCEDURE 2)".

    //procedure CreateDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SourceCodeSetup.GET;
    TableID[1] := Type1;
    No[1] := No1;
    TableID[2] := Type2;
    No[2] := No2;
    "Shortcut Dimension 1 Code" := '';
    "Shortcut Dimension 2 Code" := '';
    //****************************************Upgrade(+)
    "Shortcut Dimension 9 Code" := '';
    "Shortcut Dimension 10 Code" := '';
    "Shortcut Dimension 11 Code" := '';
    "Shortcut Dimension 12 Code" := '';
    "Shortcut Dimension 13 Code" := '';
    "Shortcut Dimension 14 Code" := '';
    //*****************************************Upgrade(-)
    "Dimension Set ID" :=
      DimMgt.GetDefaultDimID(
        TableID,No,SourceCodeSetup.Purchases,
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Shortcut Dimension 9 Code","Shortcut Dimension 10 Code",
        "Shortcut Dimension 11 Code", "Shortcut Dimension 12 Code", "Shortcut Dimension 13 Code", "Shortcut Dimension 14 Code",0,0);


    // and one cust code is left to add.
    DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Shortcut Dimension 9 Code",
    "Shortcut Dimension 10 Code","Shortcut Dimension 11 Code", "Shortcut Dimension 12 Code","Shortcut Dimension 13 Code",
     "Shortcut Dimension 14 Code");

    IF "Ref. Order No." <> '' THEN
      GetDimFromRefOrderLine(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
    #16..18
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

    DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    #27..29
    */
    //end;


    //Unsupported feature: Code Modification on "TransferFromProdOrderLine(PROCEDURE 18)".

    //procedure TransferFromProdOrderLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ProdOrder.GET(ProdOrderLine.Status,ProdOrderLine."Prod. Order No.");

    Type := Type::Item;
    "No." := ProdOrderLine."Item No.";
    "Variant Code" := ProdOrderLine."Variant Code";
    Description := ProdOrderLine.Description;
    "Description 2" := ProdOrderLine."Description 2";
    "Location Code" := ProdOrderLine."Location Code";
    "Dimension Set ID" := ProdOrderLine."Dimension Set ID";
    "Shortcut Dimension 1 Code" := ProdOrderLine."Shortcut Dimension 1 Code";
    "Shortcut Dimension 2 Code" := ProdOrderLine."Shortcut Dimension 2 Code";
    //****************cust code
    //EISDIM-00.01 START
    "Shortcut Dimension 9 Code" := ProdOrderLine."Shortcut Dimension 9 Code";
    "Shortcut Dimension 10 Code" := ProdOrderLine."Shortcut Dimension 10 Code";
    "Shortcut Dimension 11 Code" := ProdOrderLine."Shortcut Dimension 11 Code";
    "Shortcut Dimension 12 Code" := ProdOrderLine."Shortcut Dimension 12 Code";
    "Shortcut Dimension 13 Code" := ProdOrderLine."Shortcut Dimension 13 Code";
    "Shortcut Dimension 14 Code" := ProdOrderLine."Shortcut Dimension 14 Code";
    //*************************
    //EISDIm-00.01 END
    "Bin Code" := ProdOrderLine."Bin Code";
    "Gen. Prod. Posting Group" := ProdOrder."Gen. Prod. Posting Group";
    "Gen. Business Posting Group" := ProdOrder."Gen. Bus. Posting Group";
    "Scrap %" := ProdOrderLine."Scrap %";
    "Order Date" := ProdOrder."Creation Date";
    "Starting Time" := ProdOrderLine."Starting Time";
    "Starting Date" := ProdOrderLine."Starting Date";
    "Ending Time" := ProdOrderLine."Ending Time";
    "Ending Date" := ProdOrderLine."Ending Date";
    "Due Date" := ProdOrderLine."Due Date";
    "Production BOM No." := ProdOrderLine."Production BOM No.";
    "Routing No." := ProdOrderLine."Routing No.";
    "Production BOM Version Code" := ProdOrderLine."Production BOM Version Code";
    "Routing Version Code" := ProdOrderLine."Routing Version Code";
    "Routing Type" := ProdOrderLine."Routing Type";
    "Replenishment System" := "Replenishment System"::"Prod. Order";
    Quantity := ProdOrderLine.Quantity;
    "Finished Quantity" := ProdOrderLine."Finished Quantity";
    "Remaining Quantity" := ProdOrderLine."Remaining Quantity";
    "Unit Cost" := ProdOrderLine."Unit Cost";
    "Cost Amount" := ProdOrderLine."Cost Amount";
    "Low-Level Code" := ProdOrder."Low-Level Code";
    "Planning Level" := ProdOrderLine."Planning Level Code";
    "Unit of Measure Code" := ProdOrderLine."Unit of Measure Code";
    "Qty. per Unit of Measure" := ProdOrderLine."Qty. per Unit of Measure";
    "Quantity (Base)" := ProdOrderLine."Quantity (Base)";
    "Finished Qty. (Base)" := ProdOrderLine."Finished Qty. (Base)";
    "Remaining Qty. (Base)" := ProdOrderLine."Remaining Qty. (Base)";
    "Indirect Cost %" := ProdOrderLine."Indirect Cost %";
    "Overhead Rate" := ProdOrderLine."Overhead Rate";
    "Expected Operation Cost Amt." := ProdOrderLine."Expected Operation Cost Amt.";
    "Expected Component Cost Amt." := ProdOrderLine."Expected Component Cost Amt.";
    "MPS Order" := ProdOrderLine."MPS Order";
    "Planning Flexibility" := ProdOrderLine."Planning Flexibility";
    "Ref. Order No." := ProdOrderLine."Prod. Order No.";
    "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
    "Ref. Order Status" := ProdOrderLine.Status;
    "Ref. Line No." := ProdOrderLine."Line No.";

    GetDimFromRefOrderLine(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    #22..61
    */
    //end;


    //Unsupported feature: Code Modification on "TransferFromPurchaseLine(PROCEDURE 15)".

    //procedure TransferFromPurchaseLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
    Item.GET(PurchLine."No.");

    Type := Type::Item;
    "No." := PurchLine."No.";
    "Variant Code" := PurchLine."Variant Code";
    Description := PurchLine.Description;
    "Description 2" := PurchLine."Description 2";
    "Location Code" := PurchLine."Location Code";
    "Dimension Set ID" := PurchLine."Dimension Set ID";
    "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
    "Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";

    //EISDIM-00.01 START
    "Shortcut Dimension 9 Code" := PurchLine."Shortcut Dimension 9 Code";
    "Shortcut Dimension 10 Code" := PurchLine."Shortcut Dimension 10 Code";
    "Shortcut Dimension 11 Code" := PurchLine."Shortcut Dimension 11 Code";
    "Shortcut Dimension 12 Code" := PurchLine."Shortcut Dimension 12 Code";
    "Shortcut Dimension 13 Code" := PurchLine."Shortcut Dimension 13 Code";
    "Shortcut Dimension 14 Code" := PurchLine."Shortcut Dimension 14 Code";
    //EISDIm-00.01 END
    "Bin Code" := PurchLine."Bin Code";
    "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
    "Gen. Business Posting Group" := PurchLine."Gen. Bus. Posting Group";
    "Low-Level Code" := Item."Low-Level Code";
    "Order Date" := PurchHeader."Order Date";
    "Starting Date" := "Order Date";
    "Ending Date" := PurchLine."Planned Receipt Date";
    "Due Date" := PurchLine."Expected Receipt Date";
    Quantity := PurchLine.Quantity;
    "Finished Quantity" := PurchLine."Quantity Received";
    "Remaining Quantity" := PurchLine."Outstanding Quantity";
    BlockDynamicTracking(TRUE);
    VALIDATE("Unit Cost",PurchLine."Unit Cost (LCY)");
    BlockDynamicTracking(FALSE);
    "Indirect Cost %" := PurchLine."Indirect Cost %";
    "Overhead Rate" := PurchLine."Overhead Rate";
    "Unit of Measure Code" := PurchLine."Unit of Measure Code";
    "Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
    "Quantity (Base)" := PurchLine."Quantity (Base)";
    "Finished Qty. (Base)" := PurchLine."Qty. Received (Base)";
    "Remaining Qty. (Base)" := PurchLine."Outstanding Qty. (Base)";
    "Routing No." := PurchLine."Routing No.";
    "Replenishment System" := "Replenishment System"::Purchase;
    "MPS Order" := PurchLine."MPS Order";
    "Planning Flexibility" := PurchLine."Planning Flexibility";
    "Ref. Order No." := PurchLine."Document No.";
    "Ref. Order Type" := "Ref. Order Type"::Purchase;
    "Ref. Line No." := PurchLine."Line No.";
    "Vendor No." := PurchLine."Buy-from Vendor No.";

    GetDimFromRefOrderLine(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
    #22..52
    */
    //end;


    //Unsupported feature: Code Modification on "TransferFromAsmHeader(PROCEDURE 52)".

    //procedure TransferFromAsmHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Item.GET(AsmHeader."Item No.");

    Type := Type::Item;
    "No." := AsmHeader."Item No.";
    "Variant Code" := AsmHeader."Variant Code";
    Description := AsmHeader.Description;
    "Description 2" := AsmHeader."Description 2";
    "Location Code" := AsmHeader."Location Code";
    "Dimension Set ID" := AsmHeader."Dimension Set ID";
    "Shortcut Dimension 1 Code" := AsmHeader."Shortcut Dimension 1 Code";
    "Shortcut Dimension 2 Code" := AsmHeader."Shortcut Dimension 2 Code";

    //*******************************************Custom For Dimension
    "Shortcut Dimension 9 Code" := AsmHeader."Shortcut Dimension 9 Code";
    "Shortcut Dimension 10 Code" := AsmHeader."Shortcut Dimension 10 Code";
    "Shortcut Dimension 11 Code" := AsmHeader."Shortcut Dimension 11 Code";
    "Shortcut Dimension 12 Code" := AsmHeader."Shortcut Dimension 12 Code";
    "Shortcut Dimension 13 Code" := AsmHeader."Shortcut Dimension 13 Code";
    "Shortcut Dimension 14 Code" := AsmHeader."Shortcut Dimension 14 Code";

    //*******************************************Custom For Dimension
    "Bin Code" := AsmHeader."Bin Code";
    "Gen. Prod. Posting Group" := AsmHeader."Gen. Prod. Posting Group";
    "Low-Level Code" := Item."Low-Level Code";
    "Order Date" := AsmHeader."Due Date";
    "Starting Date" := "Order Date";
    "Ending Date" := AsmHeader."Due Date";
    "Due Date" := AsmHeader."Due Date";
    Quantity := AsmHeader.Quantity;
    "Finished Quantity" := AsmHeader."Assembled Quantity";
    "Remaining Quantity" := AsmHeader."Remaining Quantity";
    BlockDynamicTracking(TRUE);
    VALIDATE("Unit Cost",AsmHeader."Unit Cost");
    BlockDynamicTracking(FALSE);
    "Indirect Cost %" := AsmHeader."Indirect Cost %";
    "Overhead Rate" := AsmHeader."Overhead Rate";
    "Unit of Measure Code" := AsmHeader."Unit of Measure Code";
    "Qty. per Unit of Measure" := AsmHeader."Qty. per Unit of Measure";
    "Quantity (Base)" := AsmHeader."Quantity (Base)";
    "Finished Qty. (Base)" := AsmHeader."Assembled Quantity (Base)";
    "Remaining Qty. (Base)" := AsmHeader."Remaining Quantity (Base)";
    "Replenishment System" := "Replenishment System"::Assembly;
    "MPS Order" := AsmHeader."MPS Order";
    "Planning Flexibility" := AsmHeader."Planning Flexibility";
    "Ref. Order Type" := "Ref. Order Type"::Assembly;
    "Ref. Order Status" := AsmHeader."Document Type";
    "Ref. Order No." := AsmHeader."No.";
    "Ref. Line No." := 0;

    GetDimFromRefOrderLine(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    #22..50
    */
    //end;


    //Unsupported feature: Code Modification on "TransferFromTransLine(PROCEDURE 28)".

    //procedure TransferFromTransLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TransHeader.GET(TransLine."Document No.");
    Item.GET(TransLine."Item No.");
    Type := Type::Item;
    "No." := TransLine."Item No.";
    "Variant Code" := TransLine."Variant Code";
    Description := TransLine.Description;
    "Description 2" := TransLine."Description 2";
    "Location Code" := TransLine."Transfer-to Code";
    "Dimension Set ID" := TransLine."Dimension Set ID";
    "Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
    "Shortcut Dimension 2 Code" := TransLine."Shortcut Dimension 2 Code";

    //EISDIm-00.01 START
    "Shortcut Dimension 9 Code" := TransLine."Shortcut Dimension 9 Code";
    "Shortcut Dimension 10 Code" := TransLine."Shortcut Dimension 10 Code";
    "Shortcut Dimension 11 Code" := TransLine."Shortcut Dimension 11 Code";
    "Shortcut Dimension 12 Code" := TransLine."Shortcut Dimension 12 Code";
    "Shortcut Dimension 13 Code" := TransLine."Shortcut Dimension 13 Code";
    "Shortcut Dimension 14 Code" := TransLine."Shortcut Dimension 14 Code";

    //EISDIm-00.01 END
    "Gen. Prod. Posting Group" := TransLine."Gen. Prod. Posting Group";
    "Low-Level Code" := Item."Low-Level Code";
    "Starting Date" := CALCDATE(TransLine."Outbound Whse. Handling Time",TransLine."Shipment Date");
    "Ending Date" := CALCDATE(TransLine."Shipping Time","Starting Date");
    "Due Date" := TransLine."Receipt Date";
    Quantity := TransLine.Quantity;
    "Finished Quantity" := TransLine."Quantity Received";
    "Remaining Quantity" := TransLine."Outstanding Quantity";
    BlockDynamicTracking(FALSE);
    "Unit of Measure Code" := TransLine."Unit of Measure Code";
    "Qty. per Unit of Measure" := TransLine."Qty. per Unit of Measure";
    "Quantity (Base)" := TransLine."Quantity (Base)";
    "Finished Qty. (Base)" := TransLine."Qty. Received (Base)";
    "Remaining Qty. (Base)" := TransLine."Outstanding Qty. (Base)";
    "Replenishment System" := "Replenishment System"::Transfer;
    "Ref. Order No." := TransLine."Document No.";
    "Ref. Order Type" := "Ref. Order Type"::Transfer;
    "Ref. Line No." := TransLine."Line No.";
    "Transfer-from Code" := TransLine."Transfer-from Code";
    "Transfer Shipment Date" := TransLine."Shipment Date";
    GetDimFromRefOrderLine(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    #22..42
    */
    //end;


    //Unsupported feature: Code Modification on "GetDimFromRefOrderLine(PROCEDURE 30)".

    //procedure GetDimFromRefOrderLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF AddToExisting THEN BEGIN
      i := 1;
      DimSetIDArr[i] := "Dimension Set ID";
    #4..25
            DimSetIDArr[i] := AsmHeader."Dimension Set ID"
        END;
    END;
    "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
    "Shortcut Dimension 9 Code","Shortcut Dimension 10 Code","Shortcut Dimension 11 Code",
    "Shortcut Dimension 12 Code","Shortcut Dimension 13 Code","Shortcut Dimension 14 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..28
    "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    */
    //end;


    //Unsupported feature: Code Modification on "FilterLinesWithItemToPlan(PROCEDURE 70)".

    //procedure FilterLinesWithItemToPlan();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    SETCURRENTKEY(Type,"No.");
    SETRANGE(Type,Type::Item);
    SETRANGE("No.",Item."No.");
    SETRANGE("Sales Order No.",'');
    SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
    SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
    SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
    Item.COPYFILTER("Global Dimension 1 Filter","Shortcut Dimension 1 Code");
    Item.COPYFILTER("Global Dimension 2 Filter","Shortcut Dimension 2 Code");

    //************************************************************Custom For Dimension
    Item.COPYFILTER("Global Dimension 9 Filter","Shortcut Dimension 9 Code");
    Item.COPYFILTER("Global Dimension 10 Filter","Shortcut Dimension 10 Code");
    Item.COPYFILTER("Global Dimension 11 Filter","Shortcut Dimension 11 Code");
    Item.COPYFILTER("Global Dimension 12 Filter","Shortcut Dimension 12 Code");
    Item.COPYFILTER("Global Dimension 13 Filter","Shortcut Dimension 13 Code");
    Item.COPYFILTER("Global Dimension 14 Filter","Shortcut Dimension 14 Code");
    //************************************************************Custom For Dimension

    SETRANGE("Planning Line Origin","Planning Line Origin"::" ");
    SETFILTER("Quantity (Base)",'<>0');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..10
    SETRANGE("Planning Line Origin","Planning Line Origin"::" ");
    SETFILTER("Quantity (Base)",'<>0');
    */
    //end;


    //Unsupported feature: Code Modification on "ShowDimensions(PROCEDURE 88)".

    //procedure ShowDimensions();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Dimension Set ID" :=
      DimMgt.EditDimensionSet2(
        "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Worksheet Template Name","Journal Batch Name","Line No."),
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Shortcut Dimension 9 Code","Shortcut Dimension 10 Code",
    "Shortcut Dimension 11 Code", "Shortcut Dimension 12 Code", "Shortcut Dimension 13 Code", "Shortcut Dimension 14 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
        "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    */
    //end;
}

