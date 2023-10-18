pageextension 50104 PostedSalesCrMemos extends "Posted Sales Credit Memos"
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
            }*/
            field("E-Way Bill No."; Rec."E-Way Bill No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the E-way bill number on the sale document.';
            }

        }
    }


    actions
    {
        addafter("&Print")
        {
            action(CreateIRNNo)
            {
                Caption = 'Create-IRN No';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesCrMemoHdrExtend: Record "Sales Cr.Memo Header";
                    EInvoiceGeneration: Codeunit "E-Invoice Generation";
                begin
                    IF (rec."Posting Date" >= 20201220D) AND (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) THEN BEGIN
                        IF CONFIRM('Do you want to create IRN No.?') THEN BEGIN
                            CLEAR(EInvoiceGeneration);
                            SalesCrMemoHdrExtend.RESET;
                            SalesCrMemoHdrExtend.SETRANGE("No.", rec."No.");
                            IF SalesCrMemoHdrExtend.FINDFIRST THEN;
                            IF SalesCrMemoHdrExtend."IRN Hash" = '' THEN BEGIN
                                //EInvoiceGeneration.AuthenticateCredentials("Location GST Reg. No.");
                                EInvoiceGeneration.AuthenticateCredentials(Rec."Location GST Reg. No.");
                                EInvoiceGeneration.CreditNoteIRNNumberNew(Rec);
                                Message('IRN Generated');
                            END ELSE
                                MESSAGE('IRN No. %1 already generated.', SalesCrMemoHdrExtend."IRN Hash");
                        END;
                    END ELSE
                        ERROR('IRN is not needed for unregistered customer type');
                end;
            }
            action(GenerateEWayBill)
            {
                Caption = 'Generate E Way bill';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                var
                    EWaybillGeneration: Codeunit "E Way Bill Generation";
                begin
                    if (Rec."GST Customer Type" <> Rec."GST Customer Type"::Unregistered) then begin
                        if Confirm('Do you want to generate E Way bill No.?') then begin
                            EWaybillGeneration.AuthenticateCredentials(Rec."Location GST Reg. No.");
                            EWaybillGeneration.GenerateEWayBillFromIRNSalesCreditMemo(Rec);
                        end;
                    end;
                end;
            }
            action(ModifySalesCrMemoHeader)
            {
                Caption = 'Modify Sales Cr Memo Header';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Modify Sales Cr Memo Header";
                RunPageLink = "No." = field("No.");
                ApplicationArea = All;

                trigger OnAction()
                var
                begin
                end;

            }
        }
    }
}