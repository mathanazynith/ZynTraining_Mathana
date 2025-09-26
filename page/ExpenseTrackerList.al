page 50112 "ZYN_Expense Tracker List"
{
    PageType = List;
    SourceTable = "ZYN_Expense Tracker";
    UsageCategory=Lists;
    ApplicationArea = All;
    Caption = 'Expenses';
    CardPageId = "ZYN_Expense Tracker Card";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Expense Id"; rec."Expense Id") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Date; rec.Date) { ApplicationArea = All; }
                field(Category; rec."Category") { ApplicationArea = All; }
            }
        }
        area(FactBoxes)
        {
            part(BudgetFactBox; "ZYN_Budget FactBox")
            {
                ApplicationArea = All;
                 
            }
        }
    }

    actions
    {
        area(processing)
        {
            
            action(ExpenseCategories)
            {
                Caption = 'Expense Categories';
                Image = Category;
                ApplicationArea = All;
                RunObject =Page "ZYN_Expense Category List"; 
                
            }
            action(ExportExpenses)
            {
                Caption = 'Export Expenses';
                Image = Export;
                ApplicationArea = All;
                RunObject= Report "Export Expense Report";
               
            }
            
        }
    }
}