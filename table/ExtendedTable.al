table 50127 "ZYN_Extended Table"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Text; Text[250])
        {
            Caption = 'Text';
        }
        field(5; "Customer no"; Code[10])
        {
            Caption = 'Customer no';
        }
        field(6; "Text Code Type"; Enum "ZYN_Text Code Enum")
        {
            Caption = 'Text Code Type';
            DataClassification = ToBeClassified;
        }
        field(7; "Description"; text[100])
        {
            Caption = 'Description ';
            DataClassification = ToBeClassified;
        }
         field(8; "Language code"; code[10])
        {
            Caption = 'Language code ';
            DataClassification = ToBeClassified;
        }
        
    }

    keys
    {
        key(PK;  "Document No.","Line No.","Document Type","Text Code Type") { Clustered = true; }
    }
}
