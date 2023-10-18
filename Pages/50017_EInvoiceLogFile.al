page 50105 "E-Invoice Log"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = E_Invoice_Log;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {

                }
                field("Acknowledge No."; Rec."Acknowledge No.")
                {

                }
                field("Acknowledge Date"; Rec."Acknowledge Date")
                {

                }
                field("IRN Hash"; Rec."IRN Hash")
                {

                }
                field("QR Code"; Rec."QR Code")
                {

                }
                field("Sent Response"; SendResponse)
                {

                }
                field("Output Response"; OutputResPonse)
                {

                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

            action("Ouput Payload")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                var
                    Instrm: InStream;
                    ReturnText: Text;
                begin
                    Rec.CalcFields("Output Response");
                    If rec."Output Response".HasValue() then begin
                        rec."Output Response".CreateInStream(Instrm);
                        Instrm.Read(ReturnText);
                        Message(ReturnText);
                    end;
                end;
            }
            action("Json Payload")
            {
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                var
                    Instrm: InStream;
                    ReturnText: Text;
                    Text001: Label 'Parijat C&F';
                    Test: Notification;
                begin
                    Rec.CalcFields("Sent Response");
                    If rec."Sent Response".HasValue() then begin
                        rec."Sent Response".CreateInStream(Instrm);
                        Instrm.Read(ReturnText);
                        Message(ReturnText);
                    end;
                end;
            }
        }
    }
    var
        SendResponse: Text;
        OutputResPonse: Text;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        SendResponse := Rec.SendResponse();
        OutputResPonse := Rec.GetAPIResponse();

    end;

}