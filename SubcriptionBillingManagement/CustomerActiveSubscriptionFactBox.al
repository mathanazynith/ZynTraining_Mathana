page 50221 "ZYN_CustomerSubscripFactBox"
{
    PageType = CardPart;
    SourceTable = Customer;
    Caption = 'Subscriptions';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(Subscriptions)
            {
                Caption = 'Active Subscriptions';

                field(ActiveSubscriptions; ActiveSubCount)
                {
                    ApplicationArea = All;
                    Caption = 'Active Subscriptions';
                    DrillDownPageId = "ZYN_Subscription List";

                    trigger OnDrillDown()
                    var
                        SubRec: Record ZYN_Subscription;
                    begin
                        SubRec.SetRange("Subscriber ID", Rec."No.");
                        SubRec.SetRange(Status, SubRec.Status::Active);
                        PAGE.Run(PAGE::"ZYN_Subscription List", SubRec);
                    end;
                }
            }
        }
    }

    var
        ActiveSubCount: Integer;

    trigger OnAfterGetRecord()
    var
        SubRec: Record ZYN_Subscription;
    begin
        Clear(ActiveSubCount);
        if Rec."No." <> '' then begin
            SubRec.SetRange("Subscriber ID", Rec."No.");
            SubRec.SetRange(Status, SubRec.Status::Active);
            ActiveSubCount := SubRec.Count();
        end;
    end;
}
