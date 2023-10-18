table 79904 "Posted Indent Line"
{

    fields
    {
        field(1; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; Type; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = ,"G/L Account",Item,"Fixed Asset";
        }
        field(4; "No."; code[20])
        {
            DataClassification = CustomerContent;
            // TableRelation = Item."No."; //Gaurav
        }
        field(5; "Description"; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Remaining Quantity" := Quantity;
            end;
        }
        field(7; "Required Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Required Quantity" > "Remaining Quantity" then
                    error('Required quantity should not be more than remaining quantity');
            end;
        }
        field(8; "Remaining Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "UOM"; code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Purchase Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(11; "PO No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "PO Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "MRN No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(14; "MRN Line No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Approved Qty"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(16; "HSN/SAC Code"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Full Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; Reamrk; text[200])
        {
            DataClassification = ToBeClassified;
        }

        field(25; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            //TableRelation = "Dimension Set Entry";
        }
        field(26; "Shortcut Dimension 1 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(False));
        }
        field(27; "Shortcut Dimension 2 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), blocked = const(false));
        }
        field(28; "Shortcut Dimension 4 Code"; code[10])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4), blocked = const(false));
        }




    }

    keys
    {
        key(key1; "Indent No.", "Line No")
        {
            Clustered = true;
        }
    }

}