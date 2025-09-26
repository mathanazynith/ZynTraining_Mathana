page 50201 "ZYN_MonthlySubscripPlanCard"
{
    PageType = Card;
    SourceTable = "ZYN_Monthly Subscription Plan";
    Caption = 'Monthly Subscription Plan Card';
    UsageCategory = Administration;
    ApplicationArea=All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Plan ID"; rec."Plan ID") { ApplicationArea = All; }
                field("Name"; rec.Name) { ApplicationArea = All; }
                field("Fees"; rec.Fees) { ApplicationArea = All; }
                field("Status"; rec.Status) { ApplicationArea = All;Editable=false; }
                field("Description"; rec.Description) { ApplicationArea = All; }
            }
        }
    }
}
