page 50143 "Expense category Card"
{
    PageType = Card;
    SourceTable = "Expense category";
    Caption = 'Expense Category';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Description; rec.Description) { ApplicationArea = All; }
                field(Amount; rec.Name) { ApplicationArea = All; }
                
                
            }
        }
    }

    
}