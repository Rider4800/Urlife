pageextension 50103 PostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            /*field("QR Code"; Rec."QR Code")
            {
                ToolTip = 'Specifies the value of the QR Code field.';
                ApplicationArea = All;
            }
            field("IRN No."; Rec."IRN-No.")
            {
                ToolTip = 'Specifies the value of the IRN No. field.';
                ApplicationArea = All;
            }
		
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the E-way bill number on the sale document.';
            }
            field("E-Way Bill Date"; Rec."E-Way-Bill Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the E-Way Bill Date field.';
            }*/
        }


    }


    actions
    {
        addafter(Print)
        {
            action(CreateIRNNo)
            {
                Caption = 'Create IRN No';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesInvoiceHdrExtend: Record "Sales Invoice Header";
                    EInvoiceGeneration: Codeunit "E-Invoice Generation";
                begin
                    if (Rec."Posting Date" >= 20201220D) AND (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) then begin
                        if Confirm('Do you want to create IRN No.?') then begin
                            Clear(EInvoiceGeneration);
                            SalesInvoiceHdrExtend.RESET;
                            SalesInvoiceHdrExtend.SETRANGE("No.", Rec."No.");
                            if SalesInvoiceHdrExtend.FINDFIRST then;
                            if SalesInvoiceHdrExtend."IRN Hash" = '' then begin
                                EInvoiceGeneration.AuthenticateCredentials(Rec."Location GST Reg. No.");
                                EInvoiceGeneration.GenerateInvoiceIRNNumberUpdated(Rec);
                                CurrPage.Update();
                                // Message('IRN Generated'); //Gaurav
                            end
                            else
                                Message('IRN No. %1 already generated.', SalesInvoiceHdrExtend."IRN Hash");
                        end;
                    end else
                        Error('IRN is not needed for unregistered customer type')
                end;
            }

            action(CancelIRN)
            {
                Caption = 'Cancel IRN';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                var
                    myInt: Integer;
                begin

                end;

            }
            action(Print_Report)
            {
                Caption = 'Click here to generate Report';
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    SalesInvoiceHeader.SetRange("No.", Rec."No.");
                    // SalesInv.SetRange("Document No.", Rec."No.");
                    if SalesInvoiceHeader.FindFirst() then
                        detailedGstLed.SetRange("Document No.", SalesInvoiceHeader."No.");
                    // detailedGstLed.SetRange("Document Line No.", SalesInv."Line No.");

                    if detailedGstLed.FindSet() then begin


                        if (detailedGstLed."GST Component Code" = 'IGST') and (Rec."Ship-to Name" = '') then begin
                            report.Run(50116, true, true, SalesInvoiceHeader)
                        end
                        else
                            if (detailedGstLed."GST Component Code" = 'IGST') and (Rec."Ship-to Name" <> '') then begin
                                report.Run(50107, true, true, SalesInvoiceHeader);
                            end;
                        if (detailedGstLed."GST Component Code" = 'CGST') and (detailedGstLed."GST Component Code" = 'SGST')
                        then
                            report.Run(50104, true, true, SalesInvoiceHeader);
                        // end

                        // else
                        // if (detailedGstLed."GST Component Code" = 'SGST') or (detailedGstLed."GST Component Code" = 'CGST') then begin
                        //     report.Run(50105, true, true, SalesInvoiceHeader);

                    end

                end;

            }

            action(GenerateEWayBill)
            {
                Caption = 'Generate E Way bill';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    EWaybillGeneration: Codeunit "E Way Bill Generation";
                begin
                    if (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) then begin
                        if Confirm('Do you want to generate E Way bill No.?') then begin
                            EWaybillGeneration.AuthenticateCredentials(Rec."Location GST Reg. No.");
                            EWaybillGeneration.GenerateEWayBillFromIRN(Rec);
                        end;
                    end;
                end;
            }

            action(CancelEwaybill)
            {
                Caption = 'cancel E-Way bill';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    EWaybillGeneration: Codeunit "E Way Bill Generation";
                begin
                    if Confirm('Do you want to Cancel E Way bill No.?') then begin
                        EWaybillGeneration.AuthenticateCredentials(Rec."Location GST Reg. No.");
                        EWaybillGeneration.CancelEWayBill(Rec);
                    end;
                end;
            }
            action(ModifySalesInvHeader)
            {
                Caption = 'Modify Sales Inv Header';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Modify Sales Inv Header";
                RunPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;

        SalesInvoiceHeader: Record "Sales Invoice Header";
        detailedGstLed: Record "Detailed GST Ledger Entry";
        SalesInv: Record "Sales Invoice Line";
}