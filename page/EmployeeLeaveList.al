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
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
               
        }}

        area(FactBoxes)
        {
            part(EmployeeAssetCue; "Employee Asset Cue FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Employee ID" = field("Employee Id"); 
            }
        }
    }
}
