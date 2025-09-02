page 50131 "End Text Part"
{
    PageType = ListPart;
    SourceTable = "Extended Table" ;
    ApplicationArea = All;
    Caption = 'End Text Content';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(" Line No."; Rec."Line No.") { ApplicationArea = All; }
                
                field("text"; Rec.Text) { ApplicationArea = All; }

            }
        }
        
    }

    
  
}
