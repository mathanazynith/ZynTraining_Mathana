table 50176 "ZYN_Leave Request"
{
    Caption = 'Leave Request';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "RequestId"; Code[20])
        {
            Caption = 'RequestId';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(2; "Employee"; Code[20])
        {
            Caption = 'Employee';
            DataClassification = CustomerContent;
            TableRelation = "ZYN_Employee Table"."Employee Id";
        }

        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup("ZYN_Employee Table"."Employee Name" where("Employee Id" = field("Employee")));
            Editable = false;
        }

        field(4; "Leave Category"; Code[30])
        {
            Caption = 'Leave Category';
            DataClassification = CustomerContent;
            TableRelation = "ZYN_Leave Category"."Category Name";
        }

        

        field(5; Reason; Text[250])
        {
            Caption = 'Reason';
            DataClassification = CustomerContent;
        }

        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
             
        }

        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
             trigger OnValidate()
    begin
        if ("Start Date" <> 0D) and ("End Date" <> 0D) then
            "No. of Days" := ("End Date" - "Start Date") + 1;
    end;
        }

        field(8; Status; Enum "ZYN_Leave Status Enum")
        {
            Caption = 'Status';
            InitValue = 'Pending';
            DataClassification = CustomerContent;
        }
        field(9; "No. of Days"; Integer) 
{
    Caption = 'No. of Days';
    Editable = false;
}
field(50000; "Remaining Leaves"; Integer)
        {
            Caption = 'Remaining Leaves';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = lookup("ZYN_Hidden Table"."Remaining Leaves"
                where("Employee Id" = field("Employee"),
                      "Category Name" = field("Leave Category")));
        }
    }

    keys
    {
        key(PK; "RequestId")
        {
            Clustered = true;
        }
    }
   

    trigger OnInsert()
    var
        LastIndex: Record "ZYN_Leave Request";
        LastId: Integer;
        LastIdStr: Code[20];
    begin
        if "RequestId" = '' then begin
            if LastIndex.FindLast() then
                Evaluate(LastId, CopyStr(LastIndex."RequestId", 4))
            else
                LastId := 0;

            LastId += 1;
            LastIdStr := 'Req' + PadStr(Format(LastId), 3, '0');
            "RequestId" := LastIdStr;
        end;
        
    end;
    trigger OnDelete()
    begin
        if (Status = Status::Approved) or (Status = Status::Rejected) then
            Error('You cannot delete a %1 leave request (Request ID: %2). Only Pending requests can be deleted.',
                  Format(Status), "RequestId");
    end;
    
}
