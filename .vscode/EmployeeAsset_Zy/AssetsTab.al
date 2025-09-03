table 50188 Assets
{
    Caption = 'Assets';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Serial No."; Code[40])
        {
            Caption = 'Serial No.';
            DataClassification = ToBeClassified;
            
        }

        field(2; "Asset Type";code[20])
        {
            Caption = 'Asset Type';
            DataClassification = ToBeClassified;
            TableRelation = "Asset Type".Name;  
        }

        field(3; "Procured Date"; Date)
        {
            Caption = 'Procured Date';
            DataClassification = ToBeClassified;
        }

        field(4; "Vendor"; Text[100])
        {
            Caption = 'Vendor';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Serial No.")
        {
            Clustered = true;
        }
    }
    
    
}
