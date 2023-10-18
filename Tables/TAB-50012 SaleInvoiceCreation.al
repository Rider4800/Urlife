table 50012 SaleInvoiceCreation
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Document No."; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Doc. No';

        }
        field(3; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "No"; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF No <> xRec.No THEN BEGIN
                    RecSaleRec.GET;
                    RecSaleRec.TESTFIELD("Create Sale Inv");
                    NoSeriesMgt.TestManual(RecSaleRec."Create Sale Inv");
                    "No. Series" := '';
                END;
            end;

        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; Type; Text[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document type';

        }
        field(8; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
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

        if No = '' then begin
            RecSaleRec.GET;
            RecSaleRec.TESTFIELD("Create Sale Inv");
            No := NoSeriesMgt.GetNextNo(RecSaleRec."Create Sale Inv", WorkDate, true);
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