page 50124 "ZYN_Index Entry Subpage"
{
    PageType = ListPart;
    SourceTable = "ZYN_Index Entry";
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field(Year; Rec.Year) { ApplicationArea = All; }
                field(Value; Rec.Value) { ApplicationArea = All; }
            }
        }
    }
}
