table 50225 "ZYN_Claim Category"
{
    Caption = 'Claim Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }

        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }

        field(3; Subtype; Text[50])
        {
            Caption = 'Subtype';
            DataClassification = CustomerContent;
        }

        field(4; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(5; "Amount Limit"; Decimal)
        {
            Caption = 'Amount Limit';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code, name, Subtype)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Code, Name)
        {
        }
    }
}