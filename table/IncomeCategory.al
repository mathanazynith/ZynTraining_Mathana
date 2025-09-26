table 50131 "ZYN_Income Category"
{
    Caption = 'Income Category';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; Name; code[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown;Name)
        {
        }
    }


}