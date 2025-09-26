page 50110 "ZYN_Expense Category List"
{
    PageType = List;
    SourceTable = "ZYN_Expense Category";
    Caption = 'Expense Categories';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "ZYN_Expense category Card";

    layout
    {
        area(content)
        {
                 repeater(Group)
            {
                Editable = false;
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }

        area(FactBoxes)
        {
            
            part(ExpenseSummaryPart; "ZYN_ExpenseCategoryFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name);
            }
             part(BudgetSummaryPart; "ZYN_BudgetCategoryFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name);
            }

           
            part(RemainingBudgetPart; "ZYN_RemainingBudgetFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name); 
            }
        }
    }
}
  