table 50113 "ZYN_Buffer Field"
{
    DataClassification = ToBeClassified;
 
    fields
    {
        field(1; "Field ID"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Field Name"; Text[100]) { }

        field(3;"Record Id"; RecordId) {}

    }
 
    keys
    {
        key(PK; "Field ID","Field Name") { Clustered = true; }
    }}