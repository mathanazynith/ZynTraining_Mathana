page 50114 "ZYN_Standard Text Line Part"
{
    PageType = ListPart;
    SourceTable = "ZYN_Extended Table" ;
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
