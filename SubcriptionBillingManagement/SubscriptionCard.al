page 50206 "ZYN_Subscription Card"
{
    PageType = Card;
    SourceTable = ZYN_Subscription;
    Caption = 'Subscription Card';
    UsageCategory = Administration;
    ApplicationArea=All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Subscription ID"; rec."Subscription ID") { ApplicationArea = All; }
                field("Plan ID"; rec."Plan ID") { ApplicationArea = All; }
                field("Subscriber ID"; rec."Subscriber ID") { ApplicationArea = All; }
                field("Start Date"; rec."Start Date") { ApplicationArea = All; }
                field("Number of Months"; rec."Number of Months") { ApplicationArea = All; }
                field("End Date"; rec."End Date") { ApplicationArea = All; Editable = false; }
                field("Next Billing Date"; rec."Next Billing Date") { ApplicationArea = All; Editable = false; }
                field("Status"; rec.Status) { ApplicationArea = All;Editable =false; }
                
                field("Next Renewal Date"; rec."Next Renewal Date") { ApplicationArea = All;Editable =false; }
                
                field("Reminder Sent"; rec."Reminder Sent") { ApplicationArea = All;Editable =false; }
            }
        }
    }
}
