page 50128 "Expense Tracker Card"
{
    PageType = Card;
    SourceTable = "Expense Tracker";
    Caption = 'Expense card';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Expense Id"; rec."Expense Id") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Date; rec.Date) { ApplicationArea = All; }
                field(Category; rec."Category")
                
                {
                    ApplicationArea = All;
                }
                field("Remaining Budget (Month)"; rec.RemainingBudget)
            {
                ApplicationArea = All;
                Editable = false;
            }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Manage Categories")
            {
                Caption = 'Expense Categories';
                Image = Category;
                ApplicationArea = All;

                RunObject = page "Expense Category List";
                RunPageMode = View;
            }
        }
    }
}