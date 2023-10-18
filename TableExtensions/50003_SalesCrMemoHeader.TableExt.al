tableextension 50103 SalesCrMemoHeader extends "Sales Cr.Memo Header"
{
    fields
    {
        /*  field(50000; "IRN No."; Text[70])
         {
             DataClassification = ToBeClassified;
         }
         field(50001; "Ack No."; text[20])
         {
             DataClassification = ToBeClassified;
         }
         field(50002; "AcK Date"; DateTime)
         {
             DataClassification = ToBeClassified;
         }
         
         field(50004; "E - Invoicing QR Code"; Blob)
         {
             Subtype = Bitmap;
             DataClassification = ToBeClassified;
         }*/
        field(50103; "Cancel Remarks"; Enum "Cancel Remarks")
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "E-Way Bill Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}