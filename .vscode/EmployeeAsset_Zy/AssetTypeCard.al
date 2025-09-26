page 50187 "ZYN_Asset type card"
{
    PageType=Card;
    SourceTable="ZYN_Asset Type";
    Caption='Asset Type card ';
    ApplicationArea=all;
    UsageCategory=Administration;
   
    layout
    {
        area(content)
        {
            group(general)
            {
                field(Category; rec."Category")
                {
                    ApplicationArea=All;
                }
                field(Name;rec.Name)
                {
                    ApplicationArea=All;
                }
            }
        }
    }

}