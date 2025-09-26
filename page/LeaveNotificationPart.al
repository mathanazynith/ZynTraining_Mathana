page 50191 "ZYN_Leave Notification Part"
{
    PageType = CardPart; 
    ApplicationArea = All;
    SourceTable = "ZYN_Leave Request";
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
        LeaveRec: Record "ZYN_Leave Request";
        LeaveNotifCU: Codeunit "ZYN_Leave Notification CU";
    begin
        LeaveNotifCU.ShowLeaveNotification();
    end;

}
