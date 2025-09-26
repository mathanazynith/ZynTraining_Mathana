page 50134 "ZYN_Income Tracker List"
{
    PageType = List;
    SourceTable = "ZYN_IncomeTracker";
    UsageCategory=Lists;
    ApplicationArea = All;
    Caption = 'Incomes';
    
    CardPageId = "ZYN_Income Tracker Card";
   

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Income Id"; rec."Income Id") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Date; rec.Date) { ApplicationArea = All; }
                field(Category; rec."InCategory") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            
            action(incomeCategories)
            {
                Caption = 'Income Categories';
                Image = Category;
                ApplicationArea = All;
                RunObject =Page "ZYN_Income Category List"; 
                
            }
            action(ExportIncomes)
            {
                Caption = 'Export Incomes';
                Image = Export;
                ApplicationArea = All;
                RunObject= Report "Export Income Report";
               
            }
            
        }
    }
}