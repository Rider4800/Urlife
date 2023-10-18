xmlport 50005 SaleInvoiceCreation
{
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Job';
                MinOccurs = Zero;
                UseTemporary = true;
                textelement(CustomerNo)
                {
                    MinOccurs = Once;
                }
                textelement(ExternalDocNo)
                {

                }
                textelement(PostingDate)
                {

                }
                textelement(types)
                {

                }
                textelement(No_Line)
                {
                }

                textelement(quantities)
                {

                }
                textelement(DirectUnitCost)
                {

                }
                textelement(DeferralCode)
                {

                }
                textelement(GSTGroupCode)
                {

                }
                textelement(HSNSACCode)
                {

                }
                textelement(Dimension1)
                {

                }
                textelement(Dimension2)
                {

                }
                trigger OnAfterInitRecord()
                begin
                    INT += 1;
                    IF INT = 1 THEN
                        currXMLport.SKIP;
                    Integer.Number := INT;
                end;

                trigger OnAfterInsertRecord()
                begin
                    IF LineCount <> 0 THEN BEGIN
                        EVALUATE(VarQuantity, quantities);
                        Evaluate(VarPostingDate, PostingDate);
                        Evaluate(VarDirectUnitCost, DirectUnitCost);
                        Evaluate(VarTypes, types);

                        SaleInvoiceCreateHeader.RESET;
                        SaleInvoiceCreateHeader.SETCURRENTKEY("External Document No.");
                        SaleInvoiceCreateHeader.SetRange("External Document No.", ExternalDocNo);
                        IF SaleInvoiceCreateHeader.FINDFIRST THEN BEGIN
                            SaleInvoiceCreateLine.Reset();
                            SaleInvoiceCreateLine.SetRange("Document No.", SaleInvoiceCreateHeader."No.");
                            if SaleInvoiceCreateLine.FindLast() then
                                CreateSaleLineNo := SaleInvoiceCreateLine."Line No." + 10000
                            else
                                CreateSaleLineNo := SaleInvoiceCreateLine."Line No." + 10000;

                            SaleInvoiceCreateLine.Reset();
                            SaleInvoiceCreateLine.Init();
                            SaleInvoiceCreateLine.Validate("Document No.", SaleInvoiceCreateHeader."No.");
                            SaleInvoiceCreateLine.Validate("Line No.", CreateSaleLineNo);
                            SaleInvoiceCreateLine.Validate("No.", No_Line);
                            SaleInvoiceCreateLine.Validate(Type, VarTypes);
                            SaleInvoiceCreateLine.Validate(Qunatity, VarQuantity);
                            SaleInvoiceCreateLine.Validate("Direct Unit Cost", VarDirectUnitCost);
                            SaleInvoiceCreateLine.Validate("Deferral Code", DeferralCode);
                            SaleInvoiceCreateLine.Validate("GST Group Code", GSTGroupCode);
                            SaleInvoiceCreateLine.Validate("HSN/SAC Code", HSNSACCode);
                            SaleInvoiceCreateLine.Insert(true);
                        end else begin
                            SaleInvoiceCreateHeader.Reset();
                            SaleInvoiceCreateHeader.Init();
                            RecSaleRecevable.Get();
                            RecSaleRecevable.TESTFIELD("Create Sale Inv");
                            NextNo := NoSeriesManagement.GetNextNo(RecSaleRecevable."Create Sale Inv", WORKDATE, TRUE);
                            SaleInvoiceCreateHeader.Validate("No.", NextNo);
                            SaleInvoiceCreateHeader.Validate("Customer No.", CustomerNo);
                            SaleInvoiceCreateHeader.Validate("External Document No.", ExternalDocNo);
                            SaleInvoiceCreateHeader.Validate("Posting Date", VarPostingDate);
                            SaleInvoiceCreateHeader.Validate("Global Dimension Code 1", Dimension1);
                            SaleInvoiceCreateHeader.Validate("Global Dimension Code 2", Dimension2);
                            SaleInvoiceCreateHeader.Insert(true);

                            SaleInvoiceCreateLine.Init();
                            SaleInvoiceCreateLine.Validate("Document No.", NextNo);
                            SaleInvoiceCreateLine.Validate("No.", No_Line);
                            SaleInvoiceCreateLine.Validate(Type, VarTypes);
                            SaleInvoiceCreateLine.Validate(Qunatity, VarQuantity);
                            SaleInvoiceCreateLine.Validate("Direct Unit Cost", VarDirectUnitCost);
                            SaleInvoiceCreateLine.Validate("Deferral Code", DeferralCode);
                            SaleInvoiceCreateLine.Validate("GST Group Code", GSTGroupCode);
                            SaleInvoiceCreateLine.Validate("HSN/SAC Code", HSNSACCode);
                            SaleInvoiceCreateLine.Insert(true);
                        end;
                    end;
                    LineCount += 1;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1 Data has been Uploaded Successfully', (LineCount - 1));
    end;

    trigger OnPreXmlPort()
    begin
        LineCount := 1;
    end;

    var
        LineCount: Integer;
        INT: Integer;
        SaleInvoiceCreateHeader: Record "Sale Creation Header";
        SaleInvoiceCreateLine: Record "Sale Creation Line";
        VarQuantity: Decimal;
        VarPostingDate: Date;
        VarDirectUnitCost: Decimal;
        VarTypes: Enum "Sales Line Type";
        RecSaleRecevable: Record "Sales & Receivables Setup";
        NextNo: Code[20];
        NoSeriesManagement: Codeunit 396;
        CreateSaleLineNo: Integer;
}