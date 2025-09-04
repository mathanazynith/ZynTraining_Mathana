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
        // addlast(sections)   
        // {
        //     group("Employee Management")
        //     {
        //         action("Employee Assets")
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Employee Assets';
        //             RunObject = page "Employee Asset List";
                    
        //         }
        //         action("Assets")
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Assets';
        //             RunObject = page "Assets List";
                    
        //         }
        //         action("Assets Category")
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Assets Category';
        //             RunObject = page "Asset Type list";
                    
        //         }
        //     }
        // }
    }
}
