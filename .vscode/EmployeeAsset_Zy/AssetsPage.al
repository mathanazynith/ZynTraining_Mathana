page 50192 "Assets List"
{
    PageType = List;
    SourceTable = Assets;
    Caption = 'Assets';
    ApplicationArea = All;
    CardPageId="Assets Card";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                 Editable = false; 
                field("Serial No."; rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Asset Type";rec. "Asset Type")
                {
                    ApplicationArea = All;
                }
                field("Procured Date";rec. "Procured Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor"; rec."Vendor")
                {
                    ApplicationArea = All;
                }
            }
            
        }
        area(FactBoxes)
        
        {
            part(AssetStatusFactBox; "Asset Status FactBox")
            {
                ApplicationArea = All;
            }
    }
}
}