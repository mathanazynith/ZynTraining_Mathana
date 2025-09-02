page 50117 "Text part"
{
    PageType = ListPart;
    SourceTable = "Extended Table" ;
    ApplicationArea = All;
    Caption = 'Text Content';

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
