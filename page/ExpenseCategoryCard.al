page 50143 "ZYN_Expense category Card"
{
    PageType = Card;
    SourceTable = "ZYN_Expense category";
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