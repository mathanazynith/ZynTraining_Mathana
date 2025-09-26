page 50203 "ZYN_MonthlySubscripPlanList"
{
    PageType = List;
    SourceTable = "ZYN_Monthly Subscription Plan";
    Caption = 'Monthly Subscription Plan List';
    UsageCategory = Lists;
    CardPageId = "ZYN_MonthlySubscripPlanCard";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Plan ID"; Rec."Plan ID") { ApplicationArea = All; }
                field("Name"; Rec.Name) { ApplicationArea = All; }
                field("Fees"; Rec.Fees) { ApplicationArea = All; }
                field("Status"; Rec.Status) { ApplicationArea = All; }
                field("Description"; Rec.Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(InactivatePlan)
            {
                Caption = 'Inactivate Plan';
                ApplicationArea = All;
                Image = Cancel;

                trigger OnAction()
                begin
                    Rec.TestField("Plan ID");

                    if Rec.Status = Rec.Status::Inactive then
                        Error('Plan %1 is already inactive.', Rec."Plan ID");

                
                    Rec.Status := Rec.Status::Inactive;
                    Rec.Modify(true);

                    
                    Rec.InactivateSubscriptions(Rec."Plan ID");

                    Message('Plan %1 is now inactive. Related subscriptions are also inactivated.', Rec."Plan ID");
                end;
            }
        }
    }
}
