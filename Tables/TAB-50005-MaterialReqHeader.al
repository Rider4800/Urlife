table 50005 "Material Req Header"
{
    fields
    {
        field(1; "Document Type"; enum "Requisition & Indent Doc Type")
        {
            DataClassification = ToBeClassified;
            //OptionCaption = ' ,Requisiotion,Indent';
            //OptionMembers = " ",Requisiotion,Indent;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                /*
                IF "No." <> xRec."No." THEN BEGIN
                  ResponsibilityCenter.GET;
                  ResponsibilityCenter.TESTFIELD("Requsition No. Series");
                  NoSeriesMgt.TestManual(ResponsibilityCenter."Requsition No. Series");
                  "No. Series" := '';
                END;
                */
            end;
        }
        field(3; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
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
        field(5; "Shortcut Dimension 2 Code"; Code[20])
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
        field(6; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                IF Employee.GET("Employee Code") THEN BEGIN
                    "Employee First Name" := Employee."First Name";
                    "Employee Last Name" := Employee."Last Name";
                END ELSE BEGIN
                    "Employee First Name" := '';
                    "Employee Last Name" := '';
                END;
            end;
        }
        field(7; "Employee First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Employee Last Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Work Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Service Header".No.;
        }
        field(10; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Dimension set Id"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Open,Pending Store,Posted';
            OptionMembers = Open,"Pending Store",Posted;
        }
        field(14; Posted; Boolean)
        {
            Editable = true;
        }
        field(15; "Service Item Part No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Service Item Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Customer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(18; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Department Head Approver"; Code[50])
        {
            Caption = 'Department Head Approver';
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(20; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Open,Send for Approval,Approved,Rejected,Short Closed';
            OptionMembers = Open,"Send for Approval",Approved,Rejected,"Short Closed";
        }
        field(21; "Purchase Requsition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Material Req. Line".Amount WHERE("Document No." = FIELD("No.")));
        }
        field(23; "Requistion Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(50002; "Posted From Strore"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            DataClassification = ToBeClassified;
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                    EXIT;
                IF "Incoming Document Entry No." = 0 THEN
                    IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                // ELSE
                //  IncomingDocument.SetReqDoc(Rec);
            end;
        }
        field(50006; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            Description = 'Team::11772 RQ_0.1';
            TableRelation = Item WHERE(Type = CONST(Inventory));

            trigger OnValidate()
            var
                MaterialReqLine: Record "Material Req. Line";
            begin
                /*
                //Team::11772 RQ_0.1
                IF xRec."Item No."<>Rec."Item No." THEN
                  BEGIN
                    MaterialReqLine.RESET;
                    MaterialReqLine.SETRANGE("Document Type",Rec."Document Type");
                    MaterialReqLine.SETRANGE("Document No.",Rec."No.");
                    IF MaterialReqLine.FINDFIRST THEN
                      ERROR('You are not allowed to modify Item No., Delete the Material Req. Line lines first.');
                  END;
                //Team::11772 RQ_0.1
                */

            end;
        }
        field(50007; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'Team::11772 RQ_0.1';
            MinValue = 0;
        }
        field(50008; "Issued By"; Code[25])
        {
            DataClassification = ToBeClassified;
            Description = 'Team::11443RQ_0.1';
        }
        field(50009; "Purchase Indent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50010; "PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '11443';
        }
        field(50011; "Applied Req Doc No"; Code[20])
        {
            CalcFormula = Lookup("Material Req. Line"."Applied Req Doc No" WHERE("Document No." = FIELD("No."), "Document Type" = FIELD("Document Type")));
            FieldClass = FlowField;
        }
        field(50012; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50015; "Production Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50016; "Prod. Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Production Order"."No." WHERE(Status = FILTER(Released), "Source No." = FIELD("Item No."));

            trigger OnValidate()
            begin
                ProductionOrder.RESET;
                ProductionOrder.SETRANGE("No.", "Prod. Order No.");
                ProductionOrder.SETRANGE("Source No.", "Item No.");
                IF ProductionOrder.FINDFIRST THEN
                    Quantity := ProductionOrder.Quantity;
                VALIDATE("Dimension set Id", ProductionOrder."Dimension Set ID");

                DimensionSetEntry.RESET;
                DimensionSetEntry.SETRANGE("Dimension Set ID", "Dimension set Id");
                IF DimensionSetEntry.FINDFIRST THEN
                    REPEAT
                        IF DimensionSetEntry."Dimension Code" = 'BRANCH' THEN
                            "Shortcut Dimension 1 Code" := DimensionSetEntry."Dimension Value Code";
                        IF DimensionSetEntry."Dimension Code" = 'PROJECT' THEN
                            "Shortcut Dimension 2 Code" := DimensionSetEntry."Dimension Value Code";
                    UNTIL DimensionSetEntry.NEXT = 0;
            end;
        }
        field(50017; "Store In-Charge"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50018; "Department Head Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Store In-Charge Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        /* TEAM 14763
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", WORKDATE, "No.", "No. Series");
        END;
        */

        Rec."Created By" := USERID;
        Rec."Creation Date" := TODAY;
        Rec."Creation Time" := TIME;

        IF UserSetup.GET(USERID) THEN begin
            UserSetup.TestField("Department Head Approver");
            UserSetup.TestField("Store In-Charge Approver");

            Rec."Responsibility Center" := UserSetup."Purchase Resp. Ctr. Filter";
            Rec."Department Head Approver" := UserSetup."Department Head Approver";
            Rec."Store In-Charge" := UserSetup."Store In-Charge Approver";
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RequisitionReqHeader: Record "Material Req Header";
        Text001: Label 'The Requesition %1 %2 already exists.';
        RequisitionReqLine: Record "Material Req. Line";
        Text002: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        DimMgt: Codeunit DimensionManagement;
        UserSetup: Record "User Setup";
        ResponsibilityCenter: Record "Responsibility Center";
        ProductionOrder: Record "Production Order";
        DimensionSetEntry: Record "Dimension Set Entry";



    procedure ReqLineExist(): Boolean
    begin
        RequisitionReqLine.RESET;
        RequisitionReqLine.SETRANGE("Document Type", "Document Type");
        RequisitionReqLine.SETRANGE("Document No.", "No.");
        EXIT(RequisitionReqLine.FINDFIRST);
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension set Id";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension set Id");
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension set Id" THEN BEGIN
            MODIFY;
            IF ReqLineExist THEN
                UpdateAllLineDim("Dimension set Id", OldDimSetID);
        END;
    end;


    procedure RejectRequest()
    var
        RecUserSetup: Record "User Setup";
        RecApprovalLogEntries: Record "Approval Log Entries";
        RecCommentLine: Record "Comment Line";
        I: Integer;
    begin
        repeat
            I += 1;

            RecApprovalLogEntries.Reset;
            RecApprovalLogEntries.SetRange("Document No.", Rec."No.");
            RecApprovalLogEntries.SetRange("Sequence No.", I);
            RecApprovalLogEntries.SetFilter(Status, '<>%1', RecApprovalLogEntries.Status::Rejected);
            if RecApprovalLogEntries.FindSet then begin
                RecCommentLine.Reset;
                RecCommentLine.SetRange("No.", Rec."No.");
                RecCommentLine.SetRange("User ID", RecApprovalLogEntries."Approver ID");
                if I = 1 then
                    RecCommentLine.SetRange("Approval Type", RecCommentLine."Approval Type"::Sender);
                if I = 2 then
                    RecCommentLine.SetRange("Approval Type", RecCommentLine."Approval Type"::"Department Head");
                if I = 3 then
                    RecCommentLine.SetRange("Approval Type", RecCommentLine."Approval Type"::"Store In-Charge");
                if RecCommentLine.FindFirst then
                    RecApprovalLogEntries."User Comment" := RecCommentLine.Comment;
                RecApprovalLogEntries.Status := RecApprovalLogEntries.Status::Rejected;
                RecApprovalLogEntries.Modify;

                Rec."Department Head Approved" := false;
                Rec."Store In-Charge Approved" := false;
            end;
        until I = 3;

        RecCommentLine.Reset;
        RecCommentLine.SetRange("No.", Rec."No.");
        if RecCommentLine.FindSet then
            RecCommentLine.DeleteAll();
    end;


    procedure CreateApprovalEnrtyAndAssignApprover()
    var
        RecMaterialReqHeader: Record "Material Req Header";
        RecApprovalLogEntry, RecApprovalLogEntry1, RecApprovalLogEntry2 : Record "Approval Log Entries";
        Counter: Integer;
        RecCommentLine: Record "Comment Line";
    begin
        RecMaterialReqHeader.RESET;
        IF RecMaterialReqHeader.GET(RecMaterialReqHeader."Document Type"::Requisition, Rec."No.") THEN
            IF UserSetup.GET(UserId) THEN BEGIN
                UserSetup.TestField("Department Head Approver");
                UserSetup.TestField("Store In-Charge");

                RecMaterialReqHeader."Department Head Approver" := UserSetup."Department Head Approver";
                RecMaterialReqHeader."Store In-Charge" := UserSetup."Store In-Charge Approver";

                RecMaterialReqHeader."Approval Status" := RecMaterialReqHeader."Approval Status"::"Send for Approval";
                RecMaterialReqHeader.Modify;


                RecApprovalLogEntry2.Reset;
                RecApprovalLogEntry2.SetRange("Document No.", Rec."No.");
                RecApprovalLogEntry2.SetRange(Status, RecApprovalLogEntry2.Status::Created);
                if not RecApprovalLogEntry2.FindFirst then begin
                    repeat
                        RecApprovalLogEntry1.Reset;
                        if RecApprovalLogEntry1.FindLast then;

                        RecApprovalLogEntry.Reset;
                        RecApprovalLogEntry.Init;
                        if RecApprovalLogEntry1."Entry No." <> 0 then
                            RecApprovalLogEntry."Entry No." := RecApprovalLogEntry1."Entry No." + 1
                        else
                            RecApprovalLogEntry."Entry No." := 1;
                        RecApprovalLogEntry."Table ID" := Database::"Approval Log Entries";
                        RecApprovalLogEntry."Document No." := Rec."No.";
                        RecApprovalLogEntry."Document Type" := Rec."Document Type";
                        case Counter of
                            0:
                                begin
                                    RecApprovalLogEntry."Sender ID" := UserId;
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Created;
                                    RecApprovalLogEntry."Sequence No." := 1;
                                    RecCommentLine.Reset;
                                    RecCommentLine.SetRange("No.", Rec."No.");
                                    RecCommentLine.SetRange("Approval Type", RecCommentLine."Approval Type"::Sender);
                                    if RecCommentLine.FindFirst then
                                        RecApprovalLogEntry."User Comment" := RecCommentLine.Comment;
                                end;
                            1 .. 2:
                                begin
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Open;
                                    case Counter of
                                        1:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Department Head Approver";
                                                RecApprovalLogEntry."Sequence No." := 2;
                                            end;
                                        2:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Store In-Charge Approver";
                                                RecApprovalLogEntry."Sequence No." := 3;
                                            end;
                                    end;
                                end;
                        end;

                        RecApprovalLogEntry.Insert;

                        Counter += 1;
                    until Counter = 3;
                end else begin
                    Counter := 0;
                    repeat
                        RecApprovalLogEntry1.Reset;
                        if RecApprovalLogEntry1.FindLast then;

                        RecApprovalLogEntry.Reset;
                        RecApprovalLogEntry.Init;
                        if RecApprovalLogEntry1."Entry No." <> 0 then
                            RecApprovalLogEntry."Entry No." := RecApprovalLogEntry1."Entry No." + 1
                        else
                            RecApprovalLogEntry."Entry No." := 1;
                        RecApprovalLogEntry."Table ID" := Database::"Approval Log Entries";
                        RecApprovalLogEntry."Document No." := Rec."No.";
                        RecApprovalLogEntry."Document Type" := Rec."Document Type";
                        case Counter of
                            0 .. 1:
                                begin
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Open;
                                    case Counter of
                                        0:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Department Head Approver";
                                                RecApprovalLogEntry."Sequence No." := 2;
                                            end;
                                        1:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Store In-Charge Approver";
                                                RecApprovalLogEntry."Sequence No." := 3;
                                            end;
                                    end;
                                end;
                        end;

                        RecApprovalLogEntry.Insert;

                        Counter += 1;
                    until Counter = 2;
                end;
            end;
    end;
    //Added Start 26.06.2023
    //For approving the purchase indent

    procedure CreateApprovalEnrtyAndAssignApproverIndent()
    var
        RecMaterialReqHeader: Record "Material Req Header";
        RecApprovalLogEntry, RecApprovalLogEntry1, RecApprovalLogEntry2 : Record "Approval Log Entries";
        Counter: Integer;
        RecCommentLine: Record "Comment Line";
    begin
        RecMaterialReqHeader.RESET;
        IF RecMaterialReqHeader.GET(RecMaterialReqHeader."Document Type"::Indent, Rec."No.") THEN
            IF UserSetup.GET(UserId) THEN BEGIN
                UserSetup.TestField("Department Head Approver");
                UserSetup.TestField("Store In-Charge");
                RecMaterialReqHeader."Department Head Approver" := UserSetup."Department Head Approver";
                RecMaterialReqHeader."Store In-Charge" := UserSetup."Store In-Charge Approver";
                RecMaterialReqHeader."Approval Status" := RecMaterialReqHeader."Approval Status"::"Send for Approval";
                RecMaterialReqHeader.Modify;


                RecApprovalLogEntry2.Reset;
                RecApprovalLogEntry2.SetRange("Document No.", Rec."No.");
                RecApprovalLogEntry2.SetRange(Status, RecApprovalLogEntry2.Status::Created);
                if not RecApprovalLogEntry2.FindFirst then begin
                    repeat
                        RecApprovalLogEntry1.Reset;
                        if RecApprovalLogEntry1.FindLast then;

                        RecApprovalLogEntry.Reset;
                        RecApprovalLogEntry.Init;
                        if RecApprovalLogEntry1."Entry No." <> 0 then
                            RecApprovalLogEntry."Entry No." := RecApprovalLogEntry1."Entry No." + 1
                        else
                            RecApprovalLogEntry."Entry No." := 1;
                        RecApprovalLogEntry."Table ID" := Database::"Approval Log Entries";
                        RecApprovalLogEntry."Document No." := Rec."No.";
                        RecApprovalLogEntry."Document Type" := Rec."Document Type";
                        case Counter of
                            0:
                                begin
                                    RecApprovalLogEntry."Sender ID" := UserId;
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Created;
                                    RecApprovalLogEntry."Sequence No." := 1;
                                    RecCommentLine.Reset;
                                    RecCommentLine.SetRange("No.", Rec."No.");
                                    RecCommentLine.SetRange("Approval Type", RecCommentLine."Approval Type"::Sender);
                                    if RecCommentLine.FindFirst then
                                        RecApprovalLogEntry."User Comment" := RecCommentLine.Comment;
                                end;
                            1 .. 2:
                                begin
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Open;
                                    case Counter of
                                        1:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Department Head Approver";
                                                RecApprovalLogEntry."Sequence No." := 2;
                                            end;
                                        2:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Store In-Charge Approver";
                                                RecApprovalLogEntry."Sequence No." := 3;
                                            end;
                                    end;
                                end;
                        end;

                        RecApprovalLogEntry.Insert;

                        Counter += 1;
                    until Counter = 3;
                end else begin
                    Counter := 0;
                    repeat
                        RecApprovalLogEntry1.Reset;
                        if RecApprovalLogEntry1.FindLast then;

                        RecApprovalLogEntry.Reset;
                        RecApprovalLogEntry.Init;
                        if RecApprovalLogEntry1."Entry No." <> 0 then
                            RecApprovalLogEntry."Entry No." := RecApprovalLogEntry1."Entry No." + 1
                        else
                            RecApprovalLogEntry."Entry No." := 1;
                        RecApprovalLogEntry."Table ID" := Database::"Approval Log Entries";
                        RecApprovalLogEntry."Document No." := Rec."No.";
                        RecApprovalLogEntry."Document Type" := Rec."Document Type";
                        case Counter of
                            0 .. 1:
                                begin
                                    RecApprovalLogEntry.Status := RecApprovalLogEntry.Status::Open;
                                    case Counter of
                                        0:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Department Head Approver";
                                                RecApprovalLogEntry."Sequence No." := 2;
                                            end;
                                        1:
                                            begin
                                                RecApprovalLogEntry."Sender ID" := UserId;
                                                RecApprovalLogEntry."Approver ID" := UserSetup."Store In-Charge Approver";
                                                RecApprovalLogEntry."Sequence No." := 3;
                                            end;
                                    end;
                                end;
                        end;

                        RecApprovalLogEntry.Insert;

                        Counter += 1;
                    until Counter = 2;
                end;
            end;
    end;

    //Added End 26.06.2023

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record 904;
        NewDimSetID: Integer;
        ShippedReceivedItemLineDimChangeConfirmed: Boolean;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text002) THEN
            EXIT;

        RequisitionReqLine.RESET;
        RequisitionReqLine.SETRANGE("Document Type", "Document Type");
        RequisitionReqLine.SETRANGE("Document No.", "No.");
        RequisitionReqLine.LOCKTABLE;
        IF RequisitionReqLine.FINDFIRST THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(RequisitionReqLine."Dimension set Id", NewParentDimSetID, OldParentDimSetID);
                IF RequisitionReqLine."Dimension set Id" <> NewDimSetID THEN BEGIN
                    RequisitionReqLine."Dimension set Id" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      RequisitionReqLine."Dimension set Id", RequisitionReqLine."Shortcut Dimension 1 Code", RequisitionReqLine."Shortcut Dimension 2 Code");
                    RequisitionReqLine.MODIFY;
                END;
            UNTIL RequisitionReqLine.NEXT = 0;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    var
        ResponcibilityCenter: Record "Responsibility Center";
    begin
        IF "Purchase Requsition" = TRUE THEN BEGIN   //Team :: 11443 02 Nov 20
            UserSetup.GET(USERID);
            ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter");
            EXIT(ResponsibilityCenter."Requsition No. Series");
        END;

        //Team :: 11443 02 Nov 20
        IF "Purchase Indent" = TRUE THEN BEGIN
            UserSetup.GET(USERID);
            ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter");
            EXIT(ResponsibilityCenter."Indent No. Series");
        END;
        //Team :: 11443 02 Nov 20
    end;

    procedure AssistEdit(OldMaterialReqHeader: Record "Material Req Header"): Boolean
    begin
        //WITH OldMaterialReqHeader DO BEGIN
        COPY(Rec);
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldMaterialReqHeader."No. Series", OldMaterialReqHeader."No. Series") THEN BEGIN
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", WORKDATE, "No.", "No. Series");
            //NoSeriesMgt.SetSeries("No. Series");
            //Rec := RequisitionReqHeader;
            EXIT(TRUE);
        END;
        //END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        IF "Purchase Requsition" = TRUE THEN BEGIN //Team :: 11443 02 Nov 20
            UserSetup.GET(USERID);
            ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter");
            ResponsibilityCenter.TESTFIELD("Requsition No. Series");
        END;

        //Team :: 11443 02 Nov 20
        IF "Purchase Indent" = TRUE THEN BEGIN
            UserSetup.GET(USERID);
            ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter");
            ResponsibilityCenter.TESTFIELD("Indent No. Series");
        END;
        //Team :: 11443 02 Nov 20
    end;
}