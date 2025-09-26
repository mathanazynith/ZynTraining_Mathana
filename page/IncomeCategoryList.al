page 50129 "ZYN_Income Category List"
{
    PageType = List;
    SourceTable = "ZYN_Income Category";
    Caption = 'IncomeCategories';
    ApplicationArea = All;
    
    UsageCategory = Lists;
    CardPageId="ZYN_Income category Card";

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
            part(IncomeSummaryPart; "ZYN_IncomeCategoryFactBox")
            {
                ApplicationArea = All;
                
                SubPageLink = Name = FIELD(Name);
            }
        } 

    }

    
        
}

