pageextension 50105 PostedTransferShipments extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Posting Date")
        {
            /*field("E - Invoicing QR Code"; Rec."E-Invoicing-QR Code")
            {
                ToolTip = 'Specifies the value of the QR Code field.';
                ApplicationArea = All;
            }
            field("IRN No."; Rec."IRN-No.")
            {
                ToolTip = 'Specifies the value of the IRN No. field.';
                ApplicationArea = All;
            }
            */

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
                    EInvoiceGeneration: Codeunit "E-Invoice Generation";
                    LocR: Record Location;
                begin
                    iF (rec."Posting Date" >= 20201220D) THEN BEGIN
                        IF CONFIRM('Do you want to create IRN No.?') THEN BEGIN
                            CLEAR(EInvoiceGeneration);
                            IF rec."IRN No." = '' THEN BEGIN
                                LocR.GET(rec."Transfer-from Code");
                                EInvoiceGeneration.AuthenticateCredentials(LocR."GST Registration No.");
                                EInvoiceGeneration.GenerateTransferShipIRNNumberUpdated(Rec);
                                Message('IRN Generated');
                            END
                            ELSE
                                MESSAGE('IRN No. %1 already generated.', Rec."IRN No.");
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
                    LocR: Record Location;
                begin
                    LocR.Get(Rec."Transfer-from Code");
                    if Confirm('Do you want to generate E Way bill No.?') then begin
                        EWaybillGeneration.AuthenticateCredentials(LocR."GST Registration No.");
                        EWaybillGeneration.GenerateEWayBillFromIRNTrfrShipment(Rec);
                    end;
                end;
            }
            action(ModifyTransferShipmentHeader)
            {
                Caption = 'Modify Transfer Shipment Header';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Modify TransferShipment Header";
                RunPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}