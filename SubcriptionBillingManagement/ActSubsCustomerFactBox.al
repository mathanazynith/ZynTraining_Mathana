page 50221 "Customer Subscription FactBox"
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
                    DrillDownPageId = "Subscription List";

                    trigger OnDrillDown()
                    var
                        SubRec: Record Subscription;
                    begin
                        SubRec.SetRange("Subscriber ID", Rec."No.");
                        SubRec.SetRange(Status, SubRec.Status::Active);
                        PAGE.Run(PAGE::"Subscription List", SubRec);
                    end;
                }
            }
        }
    }

    var
        ActiveSubCount: Integer;

    trigger OnAfterGetRecord()
    var
        SubRec: Record Subscription;
    begin
        Clear(ActiveSubCount);
        if Rec."No." <> '' then begin
            SubRec.SetRange("Subscriber ID", Rec."No.");
            SubRec.SetRange(Status, SubRec.Status::Active);
            ActiveSubCount := SubRec.Count();
        end;
    end;
}
