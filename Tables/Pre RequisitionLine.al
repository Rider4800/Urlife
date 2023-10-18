table 50114 "Pre Requisition Line"
{

    fields
    {
        field(1; "Requisition No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,"Fixed Asset";
        }

        field(4; "No."; code[20])
        {

            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account" WHERE(Blocked = CONST(false), "Income/Balance" = const("Income Statement")) ELSE
            IF (Type = CONST(Item)) Item ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset" where(Blocked = const(false));
            trigger OnValidate()
            begin
                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GlAccount.GET("No.");
                            GlAccount.TESTFIELD("Direct Posting", TRUE);
                            Description := GlAccount.Name;
                            "HSN/SAC Code" := GlAccount."HSN/SAC Code";
                        END;
                    Type::Item:
                        BEGIN
                            Item.Get("No.");
                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Base Unit of Measure");
                            //Item.testfield("HSN/SAC Code");
                            Description := Item.Description;
                            UOM := Item."Base Unit of Measure";
                            "HSN/SAC Code" := Item."HSN/SAC Code";
                            "Full Description" := Item."Full Description";
                        END;
                    Type::"Fixed Asset":
                        begin
                            FIxedAsset.get("No.");
                            //FIxedAsset.testfield("HSN/SAC Code");
                            Description := FIxedAsset.Description;
                            "HSN/SAC Code" := FIxedAsset."HSN/SAC Code";

                        end;
                END;


            end;
        }
        field(5; "Description"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Remaining Quantity" := Quantity;
                Amount := Quantity * "Unit Price";
            end;
        }
        field(7; "Required Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Required Quantity" > "Remaining Quantity" then
                    error('Required quantity should not be more than remaining quantity');
            end;
        }
        field(8; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "UOM"; code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; "HSN/SAC Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }

        field(11; "Approved Qty"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Approved Qty" > Quantity then
                    Error('Approved Quantity must be less than quantity');
            end;
        }
        field(12; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Amount := "Unit Price" * Quantity;
            end;
        }
        field(13; "Full Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Reamrk; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            //TableRelation = "Dimension Set Entry";
        }
        field(26; "Shortcut Dimension 1 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(False));
        }
        field(27; "Shortcut Dimension 2 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), blocked = const(false));
        }
        field(28; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));
            // Caption = 'Department Code';
        }




    }

    keys
    {
        key(key1; "Requisition No.", "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        RequisitionHeader.Reset();
        RequisitionHeader.setrange("No.", Rec."Requisition No.");
        if RequisitionHeader.FindFirst then
            RequisitionHeader.TestField(Status, RequisitionHeader.Status::Open);

    end;

    trigger OnInsert()
    begin
        RequisitionHeader.Reset();
        RequisitionHeader.setrange("No.", Rec."Requisition No.");
        if RequisitionHeader.FindFirst then
            RequisitionHeader.TestField(Status, RequisitionHeader.Status::Open);


    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
        DimMgt: Codeunit DimensionManagement;
    begin

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Requisition No.", "Line No"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    var
        Item: Record 27;
        FIxedAsset: Record 5600;
        GlAccount: Record 15;
        RequisitionHeader: Record "Pre Requisition Header";

}