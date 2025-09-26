table 50123 "ZYN_Visit Log"
{
    DataClassification = ToBeClassified;
 
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
 
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
 
        field(3; "Visit Date"; Date)
        {
            DataClassification = CustomerContent;
        }
 
        field(4; "Purpose"; Text[100])
        {
            DataClassification = CustomerContent;
        }
 
        field(5; "Notes"; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }
 
    keys
    {
        key(PK; "Entry No.", "Customer No.")
       
        {
            
        }
    }
}

