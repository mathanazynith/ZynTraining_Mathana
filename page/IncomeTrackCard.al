page 50136 "Income Tracker Card"
{
    PageType = Card;
    SourceTable = "IncomeTracker";
    Caption = 'Income card';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Income Id"; rec."Income Id" ) { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Date; rec.Date) { ApplicationArea = All; }
                field(Category; rec."InCategory")
                {
                    ApplicationArea = All;
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
                Caption = 'Income Categories';
                Image = Category;
                ApplicationArea = All;

                RunObject = page "Income Category List";
                RunPageMode = View;
            }
        }
    }
}