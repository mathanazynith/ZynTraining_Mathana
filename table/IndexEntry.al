table 50121 "ZYN_Index Entry"
{
    Caption = 'Index Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            TableRelation = "ZYN_Index Header".Code;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
        }
        field(4; Value; Decimal)
        {
            Caption = 'Value';
        }
    }

    keys
    {
        key(PK; Code, "Entry No.")
        {
            Clustered = true;
        }
    }
}
