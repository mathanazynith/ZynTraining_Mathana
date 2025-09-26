page 50300 "ZYN_Recurring Invoice Card"
{
    PageType = Card;
    SourceTable = "ZYN_Recurring Sales Invoice";
    Caption = 'Recurring Invoice Card';
    UsageCategory = Tasks;
    ApplicationArea=All;
   

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Recurring Invoice ID"; rec."Recurring Invoice ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Subscription ID"; rec."Subscription ID")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SetAmountsFromSubscription();
                        CurrPage.Update(false);
                    end;
                }
                field("Plan Amount"; rec."Plan Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
