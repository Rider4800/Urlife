report 50102 Naveen
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    Caption = 'Purchase Order Report';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(compname; compname) { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(S_No; S_No) { }
            column(picture; compinfoRec.Picture) { }
            column(name; compname) { }
            column(GST_NO; GST_NO) { }
            column(Order_Date; "Order Date") { }
            column(No_; "No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(vendor_city; vendor_city) { }
            column(vendor_pin; vendor_pin) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(GstVend; GstVend) { }
            column(Vendor_name; Vendor_name) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "document no." = field("no.");
                DataItemLinkReference = "Purchase Header";
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(Unit_Price__LCY_; "Unit Cost") { }
                column(Description; Description) { }
                column(GstPer; GstPer) { }
                column(vendor_add1; vendor_add1) { }
                column(vendor_add2; vendor_add2) { }
                column(IGSTAmt; IGSTAmt) { }
                column(CGSTAmt; CGSTAmt) { }
                column(TDSAmt; TDSAmt) { }


                trigger OnAfterGetRecord()
                begin
                    clear(GstPer);
                    Clear(IGSTPer);
                    Clear(CGSTPer);
                    Clear(IGSTAmt);
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    clear(TDSAmt);
                    // RecTaxTransaction.Reset();
                    // RecTaxTransaction.SetRange("Tax Record ID", "Purchase Line".RecordId);
                    // RecTaxTransaction.SetRange("Tax Type", 'GST');
                    // // RecTaxTransaction.SetRange("Value ID",'');
                    // if RecTaxTransaction.FindFirst() then begin
                    //     GstPer := RecTaxTransaction.Percent;
                    // end;

                    IGSTPer := GSTCalC.GetIGSTAmount("Purchase Line".RecordId, 1);
                    CGSTPer := GSTCalC.GetCGSTAmount("Purchase Line".RecordId, 1);
                    SGSTPer := GSTCalC.GetSGSTAmount("Purchase Line".RecordId, 1);


                    IGSTAmt := GSTCalC.GetIGSTAmount("Purchase Line".RecordId, 0);
                    CGSTAmt := GSTCalC.GetCGSTAmount("Purchase Line".RecordId, 0);
                    SGSTAmt := GSTCalC.GetSGSTAmount("Purchase Line".RecordId, 0);
                    TDSAmt := GSTCalC.GetTDSAmount("Purchase Line".RecordId, 0);

                    if IGSTPer <> 0 then
                        GstPer := IGSTPer
                    else
                        GstPer := CGSTPer;
                    S_No += 1;
                end;
            }
            trigger OnAfterGetRecord()
            var
                vendRec: Record Vendor;
            begin
                Clear(GstVend);
                Clear(vendor_city);
                Clear(vendor_pin);
                Clear(Vendor_name);
                Clear(vendor_add1);
                Clear(vendor_add2);
                vendRec.Reset();
                vendRec.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if vendRec.FindFirst() then begin
                    GstVend := vendRec."GST Registration No.";
                    vendor_city := vendRec.City;
                    vendor_pin := vendRec."Post Code";
                    Vendor_name := vendRec.Name;
                    vendor_add1 := vendRec.Address;
                    vendor_add2 := vendRec."Address 2";
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = '.\FHPL REPORT LAYOUTS\mylayoutforNaveen.rdl';
        }
    }
    trigger OnPreReport()
    begin
        compinfoRec.Get();
        compinfoRec.CalcFields(Picture);
        compname := compinfoRec.Name;
        GST_NO := compinfoRec."GST Registration No.";
    end;

    var
        myInt: Integer;
        compinfoRec: Record "Company Information";
        compname: Text[100];
        GstPer: Integer;
        GST_NO: Code[50];
        VendorRec: Record Vendor;
        GSTVendor: code[50];
        GstVend: Code[50];
        vendor_city: Text[50];
        vendor_pin: Text[50];
        Vendor_name: Text[100];
        vendor_add1: Code[50];
        vendor_add2: Code[50];
        VendorInvoice: Code[50];
        S_No: Integer;
        RecTaxTransaction: Record "Tax Transaction Value";
        GSTCalC: Codeunit 50057;
        IGSTPer: Decimal;
        CGSTPer: Decimal;

        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        SGSTPer: Decimal;
        TDSAmt: Decimal;
}