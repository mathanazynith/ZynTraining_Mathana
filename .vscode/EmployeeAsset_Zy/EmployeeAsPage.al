page 50198 "Employee Asset List"
{
    PageType = List;
    SourceTable = "Employee Asset";
    Caption = 'Employee Assets';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Employee Asset Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false; 

                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    ApplicationArea = All;
                }
                field("Returned Date"; Rec."Returned Date")
                {
                    ApplicationArea = All;
                }
                field("Lost Date"; Rec."Lost Date")
                {
                    ApplicationArea = All;
                }
                field(Availability; Rec.Availability)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
