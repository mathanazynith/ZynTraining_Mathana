page 50193 "ZYN_SubscriptionExpiryNotifier"
{
    PageType = CardPart;
    SourceTable = "ZYN_Subscription";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
    
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    var
        SubExpiryCU: Codeunit "ZYN_SubscriptionExpiryNotifier";
    begin
        
        SubExpiryCU.NotifyExpiringSubscriptions();
    end;
}
