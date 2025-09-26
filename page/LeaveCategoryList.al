page 50174 "ZYN_Leave Category List"
{
    PageType = List;
    SourceTable = "ZYN_Leave Category";
    ApplicationArea = All;
    Caption = 'Leave Category List';
    Editable = false; 
    UsageCategory = Lists;
    CardPageId = "ZYN_Leave Category Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Category Name"; rec."Category Name") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field("No. of Days Allowed"; rec."No. of Days Allowed") { ApplicationArea = All; }
            }
        }
    }

     
}
