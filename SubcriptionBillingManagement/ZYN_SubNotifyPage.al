page 50193 "Subscription Expiry Notifier"
{
    PageType = CardPart;
    SourceTable = "Subscription";
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
        SubExpiryCU: Codeunit "Subscription Expiry Notifier";
    begin
        
        SubExpiryCU.NotifyExpiringSubscriptions();
    end;
}
