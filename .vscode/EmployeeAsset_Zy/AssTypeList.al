page 50188 "Asset Type list"
{
    PageType=List;
    SourceTable="ZYN_Asset Type";
    ApplicationArea=All;
    UsageCategory=Lists;
    Caption='Asset Type List';
    CardPageId="ZYN_Asset type card";
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