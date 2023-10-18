tableextension 50104 TransferShipmentHedaer extends "Transfer Shipment Header"
{
    fields
    {
        field(50101; "IRN No."; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Ack No."; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "AcK Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Cancel Remarks"; Enum "Cancel Remarks")
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "E - Invoicing QR Code"; Blob)
        {
            Subtype = Bitmap;
            DataClassification = ToBeClassified;
        }
        field(50106; "E-Way Bill No."; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "E-Way Bill Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Cancel Reason"; Enum "e-Invoice Cancel Reason")
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;
}