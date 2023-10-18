table 50014 "Sale Creation Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    RecSaleRec.GET;
                    RecSaleRec.TESTFIELD("Create Sale Inv");
                    NoSeriesMgt.TestManual(RecSaleRec."Create Sale Inv");
                    "No. Series" := '';
                END;
            end;

        }
        field(2; "External Document No."; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Doc. No';

        }
        field(3; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Editable = false;

        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }

        field(5; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Document type';

        }
        field(6; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Created On Sale invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Global Dimension Code 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Segment Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(9; "Global Dimension Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Region Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        RecSaleRec: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit 396;

    trigger OnInsert()
    begin
        // InvtSetup.get;
        // if "No." = '' then begin
        //     recGenJournalTemplate.GET("Gen. Journal Template Code");
        //     recGenJournalTemplate.testfield("No. Series");
        //     "No." := NoSeriesMgt.GetNextNo(recGenJournalTemplate."No. Series", WorkDate, true);

        // end;

        if "No." = '' then begin
            RecSaleRec.GET;
            RecSaleRec.TESTFIELD("Create Sale Inv");
            "No." := NoSeriesMgt.GetNextNo(RecSaleRec."Create Sale Inv", WorkDate, true);
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}