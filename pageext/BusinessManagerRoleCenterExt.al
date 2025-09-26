pageextension 50192 "My Role Center Ext" extends "Business Manager Role Center"
{
    layout
    {
        addfirst(RoleCenter)
        {
            part(LeaveNotifications; "ZYN_Leave Notification Part")
            {
                ApplicationArea = All;
            }
            part(ExpiringSubscriptions; "ZYN_SubscriptionExpiryNotifier")
            {
                ApplicationArea = All;   
            }
        }
    }
}
