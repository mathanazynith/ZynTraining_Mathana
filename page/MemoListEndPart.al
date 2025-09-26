page 50140 "ZYN_Text Part ending"
{
    PageType = ListPart;
    SourceTable = "ZYN_Extended Table" ;
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
