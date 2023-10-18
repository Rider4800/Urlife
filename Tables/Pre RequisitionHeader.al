table 50113 "Pre Requisition Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    RecPurAndPay.GET;
                    RecPurAndPay.TESTFIELD("Requisition No");
                    NoSeriesMgt.TestManual(RecPurAndPay."Requisition No");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "No. Series"; code[10])
        {
            DataClassification = CustomerContent;
        }
        Field(3; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Required Date"; date)
        {
            DataClassification = CustomerContent;
        }
        field(6; "User ID"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Rejection Remarks"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Shortcut Dimension 1 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(False));
        }
        field(9; "Shortcut Dimension 2 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), blocked = const(false));
        }
        field(10; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Sent for approval",Cancel,Approved;
        }
        field(11; "Gen. Journal Template Code"; Code[10])
        {
            Caption = 'Gen. Journal Template Code';
            DataClassification = ToBeClassified;
        }
        field(12; "Location Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }

        field(13; "Requisition Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,Budgeted,"Non-Budgeted";
        }
        field(14; "Requisition Remarks"; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Department Code';
            // CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));


        }
        field(16; Amount; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Pre Requisition Line".Amount where("Requisition No." = field("No.")));

        }

        field(17; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            //TableRelation = "Dimension Set Entry";
        }




    }

    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit 396;
        UserSetup: Record 91;
        recGenJournalTemplate: Record 80;
        RecPurAndPay: Record 312;

    trigger OnInsert()
    begin
        // InvtSetup.get;
        // if "No." = '' then begin
        //     recGenJournalTemplate.GET("Gen. Journal Template Code");
        //     recGenJournalTemplate.testfield("No. Series");
        //     "No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", WorkDate, true);

        // end;

        if "No." = '' then begin
            RecPurAndPay.GET;
            RecPurAndPay.TESTFIELD("Requisition No");
            "No." := NoSeriesMgt.GetNextNo(RecPurAndPay."Requisition No", WorkDate, true);
        END;

        "Posting Date" := WorkDate();
        "Document Date" := WorkDate();
        "User ID" := USERID;
        "Location Code" := recGenJournalTemplate."Location Code";
        "Shortcut Dimension 1 Code" := recGenJournalTemplate."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := recGenJournalTemplate."Shortcut Dimension 2 Code";

        if UserSetup.Get(UserID) then begin
            "Shortcut Dimension 4 Code" := UserSetup."Department Code";


        end;
    end;

    trigger OnDelete()
    begin
        Rec.testfield(Status, Rec.Status::Open);
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        DimMgt: Codeunit DimensionManagement;
    begin

        OldDimSetID := Rec."Dimension Set ID";
        Rec."Dimension Set ID" :=

          DimMgt.EditDimensionSet(
            Rec, Rec."Dimension Set ID", StrSubstNo('%1 ', Rec."No."),
            Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
        if OldDimSetID <> rec."Dimension Set ID" then begin
            rec.Modify();
            if RequisitionLinesExist() then
                UpdateAllLineDim(Rec."Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        RequisitionLine: Record "Pre Requisition Line";
        xRequisitionLine: Record "Pre Requisition Line";
        NewDimSetID: Integer;
        ShippedReceivedItemLineDimChangeConfirmed: Boolean;
        IsHandled: Boolean;
        DimMgt: Codeunit DimensionManagement;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm('You may have changed a dimension.\\Do you want to update the lines?') then
            exit;

        RequisitionLine.Reset();
        RequisitionLine.SetRange("Requisition No.", Rec."No.");
        RequisitionLine.LockTable();
        if RequisitionLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(RequisitionLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if RequisitionLine."Dimension Set ID" <> NewDimSetID then begin
                    xRequisitionLine := RequisitionLine;
                    RequisitionLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      RequisitionLine."Dimension Set ID", RequisitionLine."Shortcut Dimension 1 Code", RequisitionLine."Shortcut Dimension 2 Code");

                    RequisitionLine.Modify();
                end;
            until RequisitionLine.Next() = 0;
    end;


    procedure RequisitionLinesExist(): Boolean
    var
        RequisitionLine: Record "Pre Requisition Line";
    begin
        RequisitionLine.Reset();
        RequisitionLine.SetRange("Requisition No.", Rec."No.");
        exit(not RequisitionLine.IsEmpty());
    end;


}