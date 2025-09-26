page 50175 "ZYN_Leave Category Card"
{
    PageType = Card;
    SourceTable = "ZYN_Leave Category";
    ApplicationArea = All;
    Caption = 'Leave Category Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Category Name"; rec."Category Name") { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field("No. of Days Allowed"; rec."No. of Days Allowed") { ApplicationArea = All; }
            }
        }
    }
}
