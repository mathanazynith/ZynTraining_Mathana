page 50122 "Index List"
{
    PageType = List;
    SourceTable = "Index Header";
    ApplicationArea = All;
    Caption = 'Index List';
    UsageCategory = Lists;
    CardPageId = "Index Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Percentage Increase"; Rec."Percentage Increase") { ApplicationArea = All; }
            }
        }
    }
}
