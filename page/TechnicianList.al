page 50106 "Technician List"
{
    PageType = List;
    SourceTable = "Technician";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Technician List';
    CardPageId = "Technician Card";

    layout
    {
        area(content)
        {
            repeater(Group)  
            {
                
                field("Tech. Id"; Rec."Tech. Id") 
                { 
                    ApplicationArea = All; 
                }
                field(Name; Rec.Name) 
                { 
                    ApplicationArea = All; 
                }
                field("Phone Number"; Rec."Phone Number") 
                { 
                    ApplicationArea = All; 
                }
                field(Department; Rec.Department) 
                { 
                    ApplicationArea = All;
                 }
                field("Problem Count"; Rec."Problem Count")
                {
                     ApplicationArea = All;
                }

            }
             part("Assigned Problems"; "Technician Problems")
            {
                ApplicationArea = All;
                SubPageLink = "Technician" = FIELD("Tech. Id");

            }
        
        }
        
        

    }
    


    actions
    {
        area(processing)
        {
            
        }
    }
    

}
