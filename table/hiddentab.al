table 50180 "ZYN_Hidden Table"
{
    Caption = 'Hidden Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Id"; Code[20])
        {
            Caption = 'Employee Id';
            DataClassification = CustomerContent;
            TableRelation = "ZYN_Employee Table"."Employee Id";
        }

        field(2; "Category Name"; Code[30])
        {
            Caption = 'Category Name';
            DataClassification = CustomerContent;
            TableRelation = "ZYN_Leave Category"."Category Name";
        }

        field(3; "Days Allotted"; Integer)
        {
            Caption = 'Days Allotted';
            FieldClass = FlowField;
            CalcFormula = lookup("ZYN_Leave Category"."No. of Days Allowed"
                                 where("Category Name" = field("Category Name")));
            Editable = false;
        }

        field(4; "Leaves Taken"; Integer)
        {
            Caption = 'Leaves Taken';
            FieldClass = FlowField;
            CalcFormula = sum("ZYN_Leave Request"."No. of Days"
                      where("Employee" = field("Employee Id"),
                            "Leave Category" = field("Category Name"),
                            Status = const(Approved)));
            Editable = false;
        }

        field(5; "Remaining Leaves"; Integer)
        {
            Caption = 'Remaining Leaves';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Employee Id", "Category Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
begin
    RecalcRemaining(); 
end;

trigger OnModify()
begin
    RecalcRemaining(); 
end;


procedure RecalcRemaining()
var
    DaysAllottedVal: Integer;
    LeavesTakenVal: Integer;
begin
   
    CalcFields("Days Allotted", "Leaves Taken");

    
    DaysAllottedVal := "Days Allotted";
    LeavesTakenVal := "Leaves Taken";

    
    "Remaining Leaves" := DaysAllottedVal - LeavesTakenVal;
    if "Remaining Leaves" < 0 then
        "Remaining Leaves" := 0; 
end;

}
