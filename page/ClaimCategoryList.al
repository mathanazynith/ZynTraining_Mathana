page 50227 "Claim Category List"
{
    PageType = List;
    SourceTable = "Claim Category";
    Caption = 'Claim Category List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Claim Category Card";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Code; rec.Code) { ApplicationArea = All; }
                field(Name; rec.Name) { ApplicationArea = All; }
                field(Subtype; rec.Subtype) { ApplicationArea = All; }
                field(Description; rec.Description) { ApplicationArea = All; }
                field("Amount Limit"; rec."Amount Limit") { ApplicationArea = All; }
            }
        }
    }
}
