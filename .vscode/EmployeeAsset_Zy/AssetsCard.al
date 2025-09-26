page 50190 "ZYN_Assets Card"
{
    PageType = Card;
    SourceTable = ZYN_Assets;
    Caption = 'Assets Card';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Serial No."; rec."Serial No.")
                {
                    ApplicationArea = All;
                     
                }
                field("Asset Type"; rec."Asset Type")
                {
                    ApplicationArea = All;
                }
                field("Procured Date"; rec."Procured Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor"; rec."Vendor")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
