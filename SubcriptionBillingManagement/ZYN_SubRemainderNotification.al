codeunit 50250 "Subscription Expiry Notifier"
{
    Subtype = Normal;

    procedure NotifyExpiringSubscriptions()
    var
        SubRec: Record Subscription;
        EndDateLimit: Date;
        ExpiryNotification: Notification;
        NotificationMessage: Text;
    begin
        EndDateLimit := WorkDate() + 15;

        SubRec.Reset();
        SubRec.SetRange(Status, SubRec.Status::Active);
        SubRec.SetRange("Reminder Sent", false);
        SubRec.SetFilter("End Date", '%1..%2', WorkDate(), EndDateLimit);

        NotificationMessage := '';

        if SubRec.FindSet() then
            repeat
                
                NotificationMessage += 
                  StrSubstNo(
                    'Subscription %1 for Customer %2 will expire on %3.' + '\1',
                    SubRec."Subscription ID",
                    SubRec."Subscriber ID",
                    Format(SubRec."End Date")
                  );

                
                SubRec."Reminder Sent" := true;
                SubRec.Modify(true);
            until SubRec.Next() = 0;

        
        if NotificationMessage <> '' then begin
            ExpiryNotification.Message := NotificationMessage;
            ExpiryNotification.Scope := NotificationScope::LocalScope;
            ExpiryNotification.Send();
        end;
    end;
}
