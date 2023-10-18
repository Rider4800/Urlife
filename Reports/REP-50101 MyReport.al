report 50101 SaleInvoiceExcel
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    // dataset
    // {
    //     dataitem("Sales Invoice Header"; "Sales Invoice Header")
    //     {

    //     }

    // }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        MakeHeader();

    end;

    trigger OnPostReport()
    begin
        CreateExcelBook(); // Create Excel Book
    end;

    var
        myInt: Integer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        CustomerNo: Code[250];

    local procedure MakeHeader()
    var
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('customer No', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('External Doc No.', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Segment Code', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Region Code', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Type', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('No.', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Quantity', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit Cost', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Deferral Code', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GST Group Code', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('HSN/SAC Code', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;


    Local procedure CreateExcelBook();
    begin
        TempExcelBuffer.CreateNewBook('SaleInvoice');
        TempExcelBuffer.WriteSheet('SaleInvoice', CompanyName, UserId);
        TempExcelBuffer.CloseBook();

        TempExcelBuffer.SetFriendlyFilename('SaleInvoice');
        TempExcelBuffer.OpenExcel();
    end;

    var
        RecSaleHeader: Record "Sales Invoice Header";
        RecSaleLine: Record "Sales Invoice Line";
        RecSaleCreditMemo: Record "Sales Cr.Memo Line";

        NetAmount: Decimal;
        NetQty: Decimal;
        ReturnQty: Decimal;
        ReturnAmount: Decimal;
}