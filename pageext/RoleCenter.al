
pageextension 50192 "My Role Center Ext" extends "Business Manager Role Center"
{
    layout
    {
        addfirst(RoleCenter)
        {
            part(LeaveNotifications; "Leave Notification Part")
            {
                ApplicationArea = All;
                
            }
        }
    }

    actions
    {
        
    }

}
