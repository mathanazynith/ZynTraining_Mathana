page 50228 "ZYN_Claim Category Card"
{
    PageType = Card;
    SourceTable = "ZYN_Claim Category";
    Caption = 'Claim Category Card';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; rec.Code) { ApplicationArea = All; }
                field(Name; rec.Name) { ApplicationArea = All; }
                field(Subtype; rec.Subtype) { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field("Amount Limit"; rec."Amount Limit") { ApplicationArea = All; }
            }
        }
    }
}
