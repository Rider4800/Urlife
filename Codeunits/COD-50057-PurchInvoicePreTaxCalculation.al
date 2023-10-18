codeunit 50057 GSTManagement
{
    trigger OnRun()
    begin

    end;


    procedure GetGSTBaseAmount(RecordIDRec: recordid): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        BaseValue: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 10);
        if TaxTransactionRec.FindFirst() then BaseValue := TaxTransactionRec.Amount else BaseValue := 0;
        exit(BaseValue);
    end;

    procedure GetIGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 3);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

    procedure GetCGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 2);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

    procedure GetSGSTAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetRange("Value ID", 6);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

    procedure GetTotalAmount(RecordIDRec: recordid): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'GST');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        TaxTransactionRec.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionRec.FindFirst() then begin
            TaxTransactionRec.CalcSums(Amount);
            TaxVal := TaxTransactionRec.Amount;
        end;
        exit(TaxVal);
    end;

    //////TDS////

    procedure GetTDSAmount(RecordIDRec: recordid; Type: Option "0","1"): decimal
    var
        TaxTransactionRec: Record "Tax Transaction Value";
        TaxVal: Decimal;
    begin
        TaxTransactionRec.reset;
        TaxTransactionRec.SetRange("Tax Record ID", RecordIDRec);
        TaxTransactionRec.SetRange("Tax Type", 'TDS');
        TaxTransactionRec.SetRange("Value Type", TaxTransactionRec."Value Type"::COMPONENT);
        // TaxTransactionRec.SetRange("Value ID", 3);
        if TaxTransactionRec.FindFirst() then begin
            if type = type::"0" then TaxVal := TaxTransactionRec.Amount;
            if Type = type::"1" then TaxVal := TaxTransactionRec.Percent;
        end;
        exit(TaxVal);
    end;

}