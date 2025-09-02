page 50129 "Income Category List"
{
    PageType = List;
    SourceTable = "Income Category";
    Caption = 'IncomeCategories';
    ApplicationArea = All;
    
    UsageCategory = Lists;
    CardPageId="Income category Card";

    layout
    {
        area(content)
        {
            
            repeater(Group)
            {
                Editable = false;
                
                field(Name; rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
         area(FactBoxes)
        {
            part(IncomeSummaryPart; "IncomeCategoryFactBox")
            {
                ApplicationArea = All;
                
                SubPageLink = Name = FIELD(Name);
            }
        } 

    }

    
        
}

