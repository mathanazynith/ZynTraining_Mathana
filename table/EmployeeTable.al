table 50170 "Employee Table"
{
    Caption = 'Employee Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Id"; Code[50])
        {
            Caption = 'Employee Id';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(3; Role; Enum "Role Enum")
        {
            Caption = 'Role';
            DataClassification = CustomerContent;
        }
        field(4; Department; Enum "Department Enum")
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        
    }

    keys
    {
        key(PK; "Employee Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    { fieldgroup(Dropdown; "Employee Name")
        {
        }
    }
   trigger OnInsert()
    var
        LastIndex: Record "Employee Table";
        LastId: Integer;
        LastIdStr: Code[20];
        LeaveCategory: Record "Leave Category";
        HiddenTable: Record "Hidden Table";
    begin
        
        if "Employee Id" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."Employee Id", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'EMP' + PadStr(Format(LastId), 3, '0');
            "Employee Id" := LastIdStr;
        end;

        
        if LeaveCategory.FindSet() then
            repeat
                if not HiddenTable.Get("Employee Id", LeaveCategory."Category Name") then begin
                    HiddenTable.Init();
                    HiddenTable."Employee Id" := "Employee Id";
                    HiddenTable."Category Name" := LeaveCategory."Category Name";
                    HiddenTable."Remaining Leaves" := LeaveCategory."No. of Days Allowed"; 
                    HiddenTable.Insert(); 
                end;
            until LeaveCategory.Next() = 0;
    end;
}