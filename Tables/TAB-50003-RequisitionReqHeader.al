table 50003 "Requisition Req. Header"
{
    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Requisition';
            OptionMembers = " ",Requisition;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    SalesSetup.GET;
                    SalesSetup.TESTFIELD("Requ-Req Nos.");
                    NoSeriesMgt.TestManual(SalesSetup."Requ-Req Nos.");
                    "No. Series" := '';
                END;
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

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
            //TEAM 14763 TableRelation = "Service Header".No.;

            trigger OnValidate()
            begin
                ServiceHeaderRec.RESET;
                ServiceHeaderRec.SETRANGE("No.", Rec."Work Order No.");
                IF ServiceHeaderRec.FINDFIRST THEN BEGIN
                    Rec."Customer Code" := ServiceHeaderRec."No.";
                    Rec."Customer Name" := ServiceHeaderRec.Name;

                    ServiceItemLineRec.RESET;
                    ServiceItemLineRec.SETRANGE("Document No.", ServiceHeaderRec."No.");
                    IF ServiceItemLineRec.FINDFIRST THEN BEGIN
                        //TEAM 14763 Rec."Service Item Part No" := ServiceItemLineRec."Service Item Part No.";
                        //TEAM 14763 Rec."Service Item Serial No" := ServiceItemLineRec."Service Item Serial No.";
                    END;
                    IF UserRec.GET(USERSECURITYID) THEN BEGIN
                        Rec.UserId := UserRec."User Name";
                        //TEAM 14763 IF UserSetupRec.GET(UserRec."User Name") THEN
                        //TEAM 14763 Rec."Location Code" := UserSetupRec."Location Code";
                    END;
                END;
            end;
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
            OptionCaption = 'Open,Pending Store,Posted';
            OptionMembers = Open,"Pending Store",Posted;
        }
        field(13; UserId; Code[20])
        {
            DataClassification = ToBeClassified;
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
        IF "No." = '' THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Requ-Req Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Requ-Req Nos.", xRec."No. Series", WORKDATE, "No.", "No. Series");
        END;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RequisitionReqHeader: Record "Requisition Req. Header";
        Text001: Label 'The Requesition %1 %2 already exists.';
        RequisitionReqLine: Record "Requisition Req. Line";
        Text002: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        DimMgt: Codeunit DimensionManagement;
        ServiceHeaderRec: Record 5900;
        ServiceItemLineRec: Record 5901;
        UserRec: Record User;
        UserSetupRec: Record "User Setup";

    procedure AssistEdit(OldReqHdr: Record "Requisition Req. Header"): Boolean
    var
        RequisitionReqHeader2: Record 50000;
    begin
        COPY(Rec);
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Requ-Req Nos.");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Requ-Req Nos.", OldReqHdr."No. Series", RequisitionReqHeader."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            IF RequisitionReqHeader2.GET("Document Type", "No.") THEN
                ERROR(Text001, LOWERCASE(FORMAT("Document Type")), "No.");
            Rec := RequisitionReqHeader;
            EXIT(TRUE);
        END;
    end;

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
}

