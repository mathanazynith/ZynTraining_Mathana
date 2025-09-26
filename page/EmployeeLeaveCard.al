page 50180 "ZYN_Employees Card"
{
    PageType = Card;
    SourceTable = "ZYN_Employee Table";
    ApplicationArea = All;
    Caption = 'Employee Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee Id"; Rec."Employee Id")
                {
                    ApplicationArea = All;
                    Editable = false;
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
              
            }
        }
    }

    actions
    {
       area(Processing)
       {
         
            action("Leave Request")
            {
                Caption = 'Leave Request';
                ApplicationArea = All;
                Image = Document;

                trigger OnAction()
                var
                    LeaveReq: Record "ZYN_Leave Request";
                begin
                    
                    LeaveReq.Init();
                    LeaveReq."Employee" := Rec."Employee Id";  
                    LeaveReq.Insert(true);

                  
                    PAGE.Run(PAGE::"ZYN_Leave Request Card", LeaveReq);
                end;
            }
        }
    }
}
