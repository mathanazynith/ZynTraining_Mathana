page 50191 "Leave Notification Part"
{
    PageType = CardPart; 
    ApplicationArea = All;
    SourceTable = "Leave Request";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Notifications)
            {
                field("Employee Id";rec. "Employee") { ApplicationArea=all;}
                
            }
        }
    }
    trigger OnOpenPage();
    var
        LeaveRec: Record "Leave Request";
        LeaveNotifCU: Codeunit "Leave Notification CU";
    begin
        LeaveNotifCU.ShowLeaveNotification();
    end;

}
