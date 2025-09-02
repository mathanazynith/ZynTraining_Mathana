page 50110 "Expense Category List"
{
    PageType = List;
    SourceTable = "Expense Category";
    Caption = 'Expense Categories';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Expense category Card";

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
            
            part(ExpenseSummaryPart; "ExpenseCategoryFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name);
            }
             part(BudgetSummaryPart; "BudgetCategoryFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name);
            }

           
            part(RemainingBudgetPart; "RemainingBudgetFactBox")
            {
                ApplicationArea = All;
                SubPageLink = Name = FIELD(Name); 
            }
        }
    }
}
  