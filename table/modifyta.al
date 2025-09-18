table 50125 "Modify Log"
{
    DataClassification = ToBeClassified;
 
    fields
     
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        
        field(2; "Customer No."; Code[50])
        {
            DataClassification = SystemMetadata;
            
            TableRelation = Customer."No.";
        }
 
        field(3; "Field change."; Text[50])
        {
            DataClassification = SystemMetadata;
            
        }
 
        field(4; "old field"; Text[50])
        {
            DataClassification = SystemMetadata;

        }
 
        field(5; "new field"; text[50])
        {
            DataClassification = SystemMetadata;
        }
 
        field(6; "User id"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
    }
 
    keys
    {
        key(PK; "Entry No.","Customer No.","Field change.") { Clustered = true; }
            
        
    }
    

}
 
 