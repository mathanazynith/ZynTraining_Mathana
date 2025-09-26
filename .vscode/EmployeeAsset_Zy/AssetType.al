table 50186 "ZYN_Asset Type"
{
    Caption = 'Asset Type';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Category"; enum "Asset Category")
        {
            DataClassification = ToBeClassified;
            Caption = 'Category';
        }
        field(2; "Name"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
    }
    keys
    {
        key(PK; "Name")
        {
            Clustered = true;
        }

    }
   
}