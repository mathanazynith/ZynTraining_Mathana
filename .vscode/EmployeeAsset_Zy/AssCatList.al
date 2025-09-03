page 50188 "Asset Type list"
{
    PageType=List;
    SourceTable="Asset Type";
    ApplicationArea=All;
    UsageCategory=Lists;
    Caption='Asset Type List';
    CardPageId="Asset type card";
    layout{
        area(content){
            repeater(group){
                Editable=false;
                field(Category;Rec.Category){
                    ApplicationArea=All;
                
                }
                field(Name;Rec.Name){
                    ApplicationArea=All;
                
                }
            }
        }
    }
}