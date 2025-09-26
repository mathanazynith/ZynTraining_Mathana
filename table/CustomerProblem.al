table 50107 "ZYN_Customer Problem"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification=SystemMetadata;
            TableRelation=Customer."No.";
            Caption = 'Customer No.';  
        }
        field(3; Problem; Enum "ZYN_Problem Type")
        {
            Caption = 'Problem';
            DataClassification = ToBeClassified;
        }

        field(4; Department; Enum "ZYN_Department Type")
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
        }

        field(5; Technician; Code[250])
        {
            Caption = 'Technician';
            TableRelation = ZYN_Technician."Tech. Id" WHERE(Department = FIELD(Department));
        }

        field(6; "Problem Description"; Text[250])
        {
            Caption = 'Problem Description';
            DataClassification = ToBeClassified;
        }
        field(7; "Report Date"; Date)
        {
            Caption = 'Report Date';
            DataClassification = SystemMetadata;
        }
        field(8;"Customer Name";Text[250])
        {DataClassification=CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}

 
 