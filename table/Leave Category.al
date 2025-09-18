table 50173 "Leave Category"
{
    Caption = 'Leave Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Category Name"; Code[50])
        {
            Caption = 'Category Name';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "No. of Days Allowed"; Integer)
        {
            Caption = 'No. of Days Allowed';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Category Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Category Name") { }
    }

   trigger OnInsert()
var
    Employee: Record "Employee Table";
    HiddenTable: Record "Hidden Table";
begin
    if Employee.FindSet() then
        repeat
            if HiddenTable.Get(Employee."Employee Id", "Category Name") then begin
                HiddenTable."Remaining Leaves" := "No. of Days Allowed";
                HiddenTable."Days Allotted" := "No. of Days Allowed";
                HiddenTable."Leaves Taken" := 0;
                HiddenTable.Modify(true);
            end else begin
                HiddenTable.Init();
                HiddenTable."Employee Id" := Employee."Employee Id";
                HiddenTable."Category Name" := "Category Name";
                HiddenTable."Days Allotted" := "No. of Days Allowed";
                HiddenTable."Leaves Taken" := 0;
                HiddenTable."Remaining Leaves" := "No. of Days Allowed";
                HiddenTable.Insert(true);
            end;
        until Employee.Next() = 0;
end;
trigger Onmodify()
var
    Employee: Record "Employee Table";
    HiddenTable: Record "Hidden Table";
begin
    if Employee.FindSet() then
        repeat
            if HiddenTable.Get(Employee."Employee Id", "Category Name") then begin
                HiddenTable."Remaining Leaves" := "No. of Days Allowed";
                HiddenTable."Days Allotted" := "No. of Days Allowed";
                HiddenTable."Leaves Taken" := 0;
                HiddenTable.Modify();
            end else begin
                HiddenTable.Init();
                HiddenTable."Employee Id" := Employee."Employee Id";
                HiddenTable."Category Name" := "Category Name";
                HiddenTable."Days Allotted" := "No. of Days Allowed";
                HiddenTable."Leaves Taken" := 0;
                HiddenTable."Remaining Leaves" := "No. of Days Allowed";
                HiddenTable.Insert(true);
            end;
        until Employee.Next() = 0;
end;

}
