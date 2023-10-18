table 50006 "Material Req. Line"
{
    // //IF (Type=CONST(Item),No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.)) ELSE "Unit of Measure"

    fields
    {
        field(1; "Document Type"; enum "Requisition & Indent Doc Type")
        {
            DataClassification = ToBeClassified;
            //OptionCaption = ' ,Requisiotion,Indent';
            //OptionMembers = " ",Requisiotion,Indent;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account" WHERE("Requisition GL" = CONST(true))
            ELSE
            IF (Type = CONST(Item)) Item; //Commented By Gaurav 26.06.2023  (Original Code )
            // TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            // ELSE
            // IF (Type = CONST(Item)) Item; //Added By Gaurav //26.06.2023 (My added code )

            trigger OnValidate()
            var
                Item: Record Item;
                GLAccount: Record "G/L Account";
            begin
                TESTFIELD(Type);
                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("Item No.") THEN BEGIN
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                        "Unit Price" := Item."Last Direct Cost";
                        "Unit of Measure Code" := Item."Base Unit of Measure";
                    END;
                END;
                IF Type = Type::"G/L Account" THEN BEGIN
                    IF GLAccount.GET("Item No.") THEN BEGIN
                        Description := GLAccount.Name;

                    END;
                END;

                //GetReqHeader;
            end;
        }
        field(5; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(9; "Dimension set Id"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Item No." <> '' THEN BEGIN
                    VALIDATE("Outstanding Quantity", Quantity);
                    IF "Unit Price" <> 0 THEN
                        VALIDATE(Amount, Quantity * "Unit Price");
                END;

                //GetReqHeader;
            end;
        }
        field(11; "Approved Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Approved Quantity" > "Outstanding Quantity" THEN
                    ERROR('Please check Approved Quantity is greater than Outstanding Quantity');

                RequisitionReqHeader.RESET;
                RequisitionReqHeader.SETRANGE("No.", "Document No.");
                RequisitionReqHeader.SETRANGE("Approval Status", RequisitionReqHeader."Approval Status"::Open);
                IF RequisitionReqHeader.FINDFIRST THEN
                    ERROR('%1', 'You can not change approve qty before send for Approval');

                "Approve Qty For IJL" := "Approved Quantity";
            end;
        }
        field(12; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(13; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Consumed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Outstanding Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = true;
        }
        field(16; "Issued Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(17; "Work Order No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Part No."; Text[30])
        {
            CalcFormula = Lookup(Item."Part No." WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(19; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Unit Price" <> 0 THEN
                    VALIDATE(Amount, Quantity * "Unit Price");
                //GetReqHeader;
            end;
        }
        field(20; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //GetReqHeader;
            end;
        }
        field(21; "Requistion Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Material Req. Line".Amount WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50000; "Posted From Strore"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Approval Status"; Option)
        {
            //CalcFormula = Lookup("Material Req Header"."Approval Status" WHERE("No." = FIELD("Document No.")));
            //Editable = false;
            //FieldClass = FlowField;
            OptionCaption = 'Open,Send for Approval,Approved,Rejected,Short Closed';
            OptionMembers = Open,"Send for Approval",Approved,Rejected,"Short Closed";
        }
        field(50003; "Approve Qty For IJL"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Approve Qty For IJL" > "Outstanding Quantity" THEN
                    ERROR('Must be equal or less than outstanding quantity');
            end;
        }
        field(50009; "Purchase Line Indent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50010; Indented; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50011; "Applied Req Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50012; "Applied Req Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50013; "PO Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50014; "PO Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50015; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50016; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
            begin
                /*
                TestStatusOpen;
                TESTFIELD("Quantity Received",0);
                TESTFIELD("Qty. Received (Base)",0);
                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                TESTFIELD("Return Qty. Shipped",0);
                TESTFIELD("Return Qty. Shipped (Base)",0);
                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                  TESTFIELD("Receipt No.",'');
                  TESTFIELD("Return Shipment No.",'');
                END;
                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Unit of Measure Code"),"Sales Order No.");
                IF (xRec."Unit of Measure" <> "Unit of Measure") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
                IF "Unit of Measure Code" = '' THEN
                  "Unit of Measure" := ''
                ELSE BEGIN
                  UnitOfMeasure.GET("Unit of Measure Code");
                  "Unit of Measure" := UnitOfMeasure.Description;
                  GetPurchHeader;
                  IF PurchHeader."Language Code" <> '' THEN BEGIN
                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                    UnitOfMeasureTranslation.SETRANGE("Language Code",PurchHeader."Language Code");
                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                  END;
                END;
                UpdateItemReference;
                IF "Prod. Order No." = '' THEN BEGIN
                  IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    GetItem;
                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                    "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                    "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                    "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                    "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                    IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                      InitItemAppl;
                    UpdateUOMQtyPerStockQty;
                  END ELSE
                    "Qty. per Unit of Measure" := 1;
                END ELSE
                  "Qty. per Unit of Measure" := 0;
                
                VALIDATE(Quantity);
                "Assessable Value" := Item."Assessable Value" * "Qty. per Unit of Measure" ;
                */

            end;
        }
        field(50017; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,G/L Account,Item';
            OptionMembers = " ","G/L Account",Item;
        }
        field(50018; "Bom Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Stock In Hand"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."), "Location Code" = FIELD("Location Code")));
            FieldClass = FlowField;
        }
        field(50020; "Location Code"; Code[10])
        {
            CalcFormula = Lookup("Material Req Header"."Location Code" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //GetReqHeader;
    end;

    trigger OnInsert()
    begin
        MaterialReqHeader.RESET;
        MaterialReqHeader.SETRANGE("No.", "Document No.");
        IF MaterialReqHeader.FINDFIRST THEN
            IF MaterialReqHeader."Item No." <> '' THEN
                ERROR('Please remove item no from header');
    end;

    trigger OnModify()
    begin
        //GetReqHeader;
    end;

    var
        DimMgt: Codeunit 408;
        RequisitionReqHeader: Record "Material Req Header";
        ReqAmt: Decimal;
        MaterialReqHeader: Record "Material Req Header";

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension set Id");
    end;

    procedure GetReqHeader()
    var
        Amount_total: Decimal;
        MaterialReqLine: Record "Material Req. Line";
    begin
        CLEAR(Amount_total);
        RequisitionReqHeader.RESET;
        RequisitionReqHeader.SETRANGE("No.", "Document No.");
        IF RequisitionReqHeader.FINDFIRST THEN BEGIN
            MaterialReqLine.RESET;
            MaterialReqLine.SETRANGE("Document No.", "Document No.");
            MaterialReqLine.SETFILTER("Unit Price", '<>%1', 0);
            IF MaterialReqLine.FINDFIRST THEN
                REPEAT
                    Amount_total += MaterialReqLine.Amount;
                UNTIL MaterialReqLine.NEXT = 0;
            RequisitionReqHeader."Total Amount" := Amount_total;
            RequisitionReqHeader.MODIFY;
        END;
    end;
}

