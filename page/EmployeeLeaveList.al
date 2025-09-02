page 50171 "Employees List"
{
    PageType = List;
    SourceTable = "Employee Table";
    ApplicationArea = All;
    Caption = 'Employee List';
    Editable = false; 
    UsageCategory = Lists;
    CardPageId = "Employees Card"; 

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee Id"; rec."Employee Id") { ApplicationArea = All; }
                field("Employee Name"; rec."Employee Name") { ApplicationArea = All; }
                field(Role; rec.Role) { ApplicationArea = All; }
                field(Department; rec.Department) { ApplicationArea = All; }
            }
        }
    }
}