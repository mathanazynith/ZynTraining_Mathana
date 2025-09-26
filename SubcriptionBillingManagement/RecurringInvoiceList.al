page 50301 "ZYN_Recurring Invoice List"
{
    PageType = List;
    SourceTable = "ZYN_Recurring Sales Invoice";
    Caption = 'Recurring Invoice List';
    UsageCategory = Lists;
    ApplicationArea=All;
     CardPageId="ZYN_Recurring Invoice Card";
    

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Recurring Invoice ID"; rec."Recurring Invoice ID")
                {
                    ApplicationArea = All;
                }
                field("Subscription ID"; rec."Subscription ID")
                {
                    ApplicationArea = All;
                }
                field("Plan Amount"; rec."Plan Amount")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
