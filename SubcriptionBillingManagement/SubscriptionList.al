page 50205 "Subscription List"
{
    PageType = List;
    SourceTable = Subscription;
    Caption = 'Subscription List';
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Subscription Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Subscription ID"; Rec."Subscription ID") { ApplicationArea = All; }
                field("Plan ID"; Rec."Plan ID") { ApplicationArea = All; }
                field("Subscriber ID"; Rec."Subscriber ID") { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("Number of Months"; Rec."Number of Months") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field("Next Billing Date"; Rec."Next Billing Date") { ApplicationArea = All; }
                field("Status"; Rec.Status) { ApplicationArea = All; }
                field("Next Renewal Date"; rec."Next Renewal Date") { ApplicationArea = All; }
                
                field("Reminder Sent"; rec."Reminder Sent") { ApplicationArea = All;}
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RejectSubscription)
            {
                Caption = 'Reject Subscription';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                begin
                    Rec.TestField("Subscription ID");

                    if Rec.Status = Rec.Status::Reject then
                        Error('Subscription %1 is already rejected.', Rec."Subscription ID");

                    Rec.Status := Rec.Status::Reject;
                    Rec.Modify(true);

                    Message('Subscription %1 has been rejected.', Rec."Subscription ID");
                end;
            }
        }
    }
}
