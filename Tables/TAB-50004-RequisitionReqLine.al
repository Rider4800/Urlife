table 50004 "Requisition Req. Line"
{
    // //UpdateWorkOrderNo::To Update Workorder no. in line from Header::6130::060820

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Requision';
            OptionMembers = " ",Requision;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                IF Item.GET("Item No.") THEN BEGIN
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                    UOM := Item."Base Unit of Measure";
                END;
                //UpdateWorkOrderNo::Start
                ReqHdr.RESET;
                ReqHdr.SETRANGE("Document Type", Rec."Document Type");
                ReqHdr.SETRANGE("No.", Rec."Document No.");
                IF ReqHdr.FINDFIRST THEN
                    "Work Order No" := ReqHdr."Work Order No.";
                //UpdateWorkOrderNo::End
            end;
        }
        field(5; Description; Text[50])
        {
            DataClassification = ToBeClassified;
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

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

            trigger OnValidate()
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("NDT user", TRUE);
                IF UserSetup.FINDFIRST THEN BEGIN
                    "Outstanding Quantity" := Quantity;
                    "Approved Quantity" := Quantity;
                END;
            end;
        }
        field(11; "Approved Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Approved Quantity" > "Outstanding Quantity" THEN
                    ERROR('Please check Approved Quantity is greater than Outstanding Quantity');
            end;
        }
        field(12; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            var
                RequisitionReqHeader: Record 50000;
                RequisitionReqLine: Record 50001;
            begin
                /*
                IF Posted THEN BEGIN
                  RequisitionReqLine.RESET;
                  RequisitionReqLine.SETRANGE("Document No.","Document No.");
                  RequisitionReqLine.SETRANGE("Document Type","Document Type");
                  RequisitionReqLine.SETFILTER(Posted,'%1',FALSE);
                  IF NOT RequisitionReqLine.FINDFIRST THEN
                    RequisitionReqHeader.SETRANGE("No.","Document No.");
                    RequisitionReqHeader.SETRANGE("Document Type","Document Type");
                    IF RequisitionReqHeader.FINDFIRST THEN
                      IF Rec."Outstanding Quantity" = 0 THEN BEGIN
                      RequisitionReqHeader.Posted:= TRUE;
                      RequisitionReqHeader.Status :=  RequisitionReqHeader.Status::Posted;
                      RequisitionReqHeader.MODIFY;
                      END
                  END;
                  */

            end;
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
        }
        field(16; "Issued Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Work Order No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Part No."; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Part No." WHERE("No." = FIELD("Item No.")));
        }
        field(19; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;
        UserSetup: Record "User Setup";
        ReqHdr: Record "Requisition Req. Header";

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension set Id");
    end;
}