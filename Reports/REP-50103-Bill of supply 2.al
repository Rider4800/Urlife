// BILL OF SUPPLY 2 REPORT
report 50103 "Bill of Supply 2"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;
    caption = 'Bill of supply 2';

    dataset
    {

        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            column(picture; compinfo.Picture) { }
            column(name; compname) { }
            column("Number"; "Sales Invoice Header"."No.") { }
            column(Posting_Date; "Sales Invoice Header"."Posting Date") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(Customer_GST_Reg__No_; "Customer GST Reg. No.") { }
            column(GST_Bill_to_State_Code; "GST Bill-to State Code") { }
            column(State; State) { }
            column(Location_State_Code; "Location State Code") { }
            column(External_Document_No_; "External Document No.") { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "document no." = field("no.");

                DataItemLinkReference = "Sales Invoice Header";
                column(Description; Description) { }
                column(GSTBaseAmtL; GSTBaseAmtL) { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(SGSTAmt; SGSTAmt) { }
                column(SGSTPer; SGSTPer) { }
                column(CGSTPer; CGSTPer) { }
                column(CGSTAmt; CGSTAmt) { }
                column(IGSTPer; IGSTPer) { }
                column(IGSTAmt; IGSTAmt) { }
                column(GSTComponent; GSTComponent) { }
                column(statecode; statecode) { }
                column(statename; statename) { }
                column(finalAmtInWords; finalAmtInWords) { }
                trigger OnPreDataItem()
                begin
                    Clear(SGSTAmt);
                    Clear(SGSTPer);
                    Clear(IGSTAmt);
                    Clear(IGSTPer);
                    Clear(CGSTAmt);
                    Clear(CGSTPer);
                    Clear(GSTBaseAmtL);
                    Clear(CurrentAmount);
                    Clear(TotalAmount);
                    Clear(FinalAmount);
                    Clear(finalAmtInWords);
                end;

                trigger OnAfterGetRecord()
                var
                    DetailedGSTLedgerEntryL: Record "Detailed GST Ledger Entry";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                begin
                    Clear(SGSTAmt);
                    Clear(SGSTPer);
                    Clear(CGSTAmt);
                    Clear(CGSTPer);
                    Clear(IGSTAmt);
                    Clear(IGSTPer);
                    DetailedGSTLedgerEntryL.Reset();
                    DetailedGSTLedgerEntryL.SetRange("Transaction Type", DetailedGSTLedgerEntryL."Transaction Type"::Sales);
                    DetailedGSTLedgerEntryL.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    DetailedGSTLedgerEntryL.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                    repeat
                        IF DetailedGSTLedgerEntryL."GST Component Code" = 'SGST' then begin
                            SGSTAmt += DetailedGSTLedgerEntryL."GST Amount";
                            SGSTPer += DetailedGSTLedgerEntryL."GST %";
                        end;
                        IF DetailedGSTLedgerEntryL."GST Component Code" = 'CGST' then begin
                            CGSTAmt += DetailedGSTLedgerEntryL."GST Amount";
                            CGSTPer += DetailedGSTLedgerEntryL."GST %";
                        end;
                        IF DetailedGSTLedgerEntryL."GST Component Code" = 'IGST' then begin
                            IGSTAmt += DetailedGSTLedgerEntryL."GST Amount";
                            IGSTPer += DetailedGSTLedgerEntryL."GST %";
                        end;
                        GSTBaseAmtL += DetailedGSTLedgerEntryL."GST Base Amount";
                    until DetailedGSTLedgerEntryL.Next = 0;
                    CurrentAmount := Quantity * "Unit Price";
                    TotalAmount += CurrentAmount;
                    FinalAmount := Round((TotalAmount + ABS(total_gst_amount)), 0.01, '=');
                    SemifinalAmtInWords := codn.amountinwords(FinalAmount);
                    Position := STRPOS(SemifinalAmtInWords, 'PAISA ONLY');
                    if Position <> 0 then begin
                        finalAmtInWords := SemifinalAmtInWords;
                    end else
                        if Position = 0 then
                            finalAmtInWords := SemifinalAmtInWords + ' ' + 'PAISA ONLY';
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(statename);
                Clear(statecode);
                StateRec.Reset();
                StateRec.SetRange(Code, "Sales Invoice Header".State);
                if StateRec.FindFirst() then begin
                    statecode := StateRec."State Code (GST Reg. No.)";
                    statename := StateRec.Description;
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
            LayoutFile = '.\FHPL REPORT LAYOUTS\Bill of supply 2.rdl';
        }
    }
    trigger OnPreReport()
    begin
        compinfo.Get();
        compinfo.CalcFields(Picture);
        compname := compinfo.Name;
    end;

    var
        myInt: Integer;
        GSTBaseAmtL: Decimal;
        GSTAmtL: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTAmt: Decimal;
        SGSTPer: Decimal;
        CGSTPer: Decimal;
        IGSTPer: Decimal;
        GSTComponent: Text;
        "DGLE": Record "Detailed GST Ledger Entry";
        compinfo: Record "Company Information";
        compname: Code[100];
        StateRec: Record State;
        statecode: Code[50];
        statename: Code[50];
        total_gst_amount: Decimal;
        TotalAmount: Decimal;
        FInalAmount: Decimal;
        codn: Codeunit int_to_words;
        finalAmtInWords: Text[400];
        reportCheck: Report "Posted Voucher";
        AmountInWords: array[2] of Text[80];
        AmountInWords1: Text[600];
        CurrentAmount: Decimal;
        Position: Integer;
        NewString: Text;
        SemifinalAmtInWords: Text;
}