page 50122 "ZYN_Index List"
{
    PageType = List;
    SourceTable = "ZYN_Index Header";
    ApplicationArea = All;
    Caption = 'Index List';
    UsageCategory = Lists;
    CardPageId = "ZYN_Index Card";
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
