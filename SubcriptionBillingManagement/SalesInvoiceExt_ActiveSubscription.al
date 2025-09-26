pageextension 50352 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    layout
    {
        addlast(Control1)   
        {
            field("From Subscription"; rec."From Subscription")
            {
                ApplicationArea = All;
                Caption = 'From Subscription';
            }
        }
    }
}
