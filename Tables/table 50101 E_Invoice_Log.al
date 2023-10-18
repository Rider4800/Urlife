table 50101 E_Invoice_Log
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Invoice,"Credit Memo";
        }
        field(3; "Sent Response"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Output Response"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "IRN Hash"; text[64])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Acknowledge No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Acknowledge Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }
    procedure SendResponse(): Text
    var
        CR: Text[1];
        instr: InStream;
        Encoding: TextEncoding;
        ContentLine: Text;
        Content: Text;
    begin
        CALCFIELDS("Sent Response");
        IF NOT "Sent Response".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "Sent Response".CreateInStream(instr, TextEncoding::Windows);
        instr.READTEXT(Content);
        WHILE NOT instr.EOS DO BEGIN
            instr.READTEXT(ContentLine);
            Content += CR[1] + ContentLine;
        END;
        exit(Content);
    end;


    procedure GetAPIResponse(): Text
    var
        CR: Text[1];
        instr: InStream;
        Encoding: TextEncoding;
        ContentLine: Text;
        Content: Text;
    begin
        CALCFIELDS("Output Response");
        IF NOT "Output Response".HASVALUE THEN
            EXIT('');
        CR[1] := 10;
        Clear(Content);
        Clear(instr);
        "Output Response".CreateInStream(instr, TextEncoding::Windows);
        instr.READTEXT(Content);
        WHILE NOT instr.EOS DO BEGIN
            instr.READTEXT(ContentLine);
            Content += CR[1] + ContentLine;
        END;
        exit(Content);
    end;


}