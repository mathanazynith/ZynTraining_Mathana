table 50100 "ZYN_Technician"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tech. Id"; code[20])
        {
            DataClassification = SystemMetadata;
        }

        field(2; "Name"; Text[100])
        {
            DataClassification = CustomerContent;
            
        
        }

        field(3; "Phone Number"; Text[20])
        {
            DataClassification = CustomerContent;
        }

        field(4; "Department"; Enum "ZYN_Department Type")
        {
            DataClassification = CustomerContent;
        }
        field(5; "Problem Count"; Integer)
        {
          Caption = 'Assigned Problems';
          FieldClass = FlowField;
          CalcFormula = count("ZYN_Customer Problem" where(Technician = field("Tech. Id")));
          Editable = false;
        }
    }

    keys
    {
        key(PK; "Tech. Id") { Clustered = true; }
    }
     trigger OnInsert()
    var
        LastTech: Record "ZYN_Technician";
        LastId: Integer;
    begin
        if "Tech. Id" = '' then begin
            if LastTech.FindLast() then
                Evaluate(LastId, LastTech."Tech. Id")
            else
                LastId := 999; 
            "Tech. Id" := Format(LastId + 1);
    end;
    end;
    
}