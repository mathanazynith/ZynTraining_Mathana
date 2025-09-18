table 50119 "Last Sold Price"
{
    Caption = 'Last Sold Price';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            DataClassification = ToBeClassified;
        }
        field(3; "Item Price"; Decimal)
        {
            Caption = 'Item Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(6 ; entryNo ; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Customer No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
