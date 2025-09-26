page 50138 "ZYN_Income category Card"
{
    PageType = Card;
    SourceTable = "ZYN_Income category";
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