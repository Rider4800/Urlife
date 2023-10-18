tableextension 50017 tableextension70000029 extends "Sales Header"
{
    fields
    {
        field(50001; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RecSalesLine: Record "Sales Line";
            begin
                if Rec."Contract Start Date" <> 0D then begin
                    RecSalesLine.Reset;
                    RecSalesLine.SetRange("Document No.", Rec."No.");
                    if RecSalesLine.FindSet then begin
                        repeat
                            RecSalesLine."Contract Start Date" := Rec."Contract Start Date";
                        until RecSalesLine.Next = 0;
                    end;
                end;

                // IF "Contract Start Date" <> 0D THEN
                //   COntractDays
                // ELSE
                //  "No of Days" := 0;
                // "No of Days" := "Contract End Date" - "Contract Start Date"
            end;
        }
        field(50002; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RecSalesLine: Record "Sales Line";
            begin
                if Rec."Contract End Date" <> 0D then begin
                    RecSalesLine.Reset;
                    RecSalesLine.SetRange("Document No.", Rec."No.");
                    if RecSalesLine.FindSet then begin
                        repeat
                            RecSalesLine."Contract End Date" := Rec."Contract Start Date";
                        until RecSalesLine.Next = 0;
                    end;
                end;

                // IF "Contract End Date" <> 0D THEN
                // COntractDays
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
            begin
                //IF ("Contract End Date" <> 0D) AND ("Contract Start Date" <> 0D) THEN
                //COntractDays;
                //"No of Days" := "Contract End Date" - "Contract Start Date"
            end;
        }
        field(50004; "Job Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnModify()
    begin
        COntractDays;
    end;

    local procedure COntractDays()
    begin
        IF (Rec."Contract End Date" <> 0D) AND (Rec."Contract Start Date" <> 0D) THEN
            Rec."No of Days" := ((Rec."Contract End Date" - Rec."Contract Start Date") DIV 30)
        ELSE
            Rec."No of Days" := 0;

        //MESSAGE('%1', "No of Days");
    end;
}