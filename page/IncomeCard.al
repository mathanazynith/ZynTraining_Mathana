page 50138 "Income category Card"
{
    PageType = Card;
    SourceTable = "Income category";
    Caption = 'Income Category';

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