page 50141 "Budget Tracker List"
{
    PageType = List;
    SourceTable = "Budget Tracker";
    Caption = 'Budget Tracker List';
    ApplicationArea = All;
    UsageCategory=Lists;
    CardPageId = "Budget Tracker Card";

    layout
    {
        area(content)
        {
            
               repeater(Group)
            {
                Editable= false;
                field("Budget Id"; rec."Budget Id")
                {
                    ApplicationArea = All;
                }
                field("From Date"; rec."From Date")
                {
                    ApplicationArea = All;
                    
                }
                field("To Date"; rec."To Date")
                {
                    ApplicationArea = All;
                    
                }
                field("Expense Category"; rec."Expense Category")
                {
                    ApplicationArea = All;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    
}
