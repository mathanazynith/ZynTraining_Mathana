codeunit 50190 "Leave Notification CU"
{
    
    Subtype = Normal;

    procedure ShowLeaveNotification()
    var
        NotificationText: Notification;
        Leaverec:Record "Leave Request";
        
        
    begin;
        
        LeaveRec.SetCurrentKey(SystemModifiedAt);
        LeaveRec.Ascending := true;
        if LeaveRec.FindLast()then begin
        NotificationText.Message := StrSubstNo('Leave Request for Employee %1 is %2 for %3 days.', Leaverec.Employee,Leaverec.Status,Leaverec."No. of Days");
        NotificationText.Scope := NotificationScope::LocalScope;
        notificationtext.Send();
        end;
    end;
}
