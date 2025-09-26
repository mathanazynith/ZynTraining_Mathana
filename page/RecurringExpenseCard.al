page 50152 "ZYN_Recurring Expense Card"
{
    PageType = Card;
    SourceTable = "ZYN_Recurring Expense";
    ApplicationArea = All;
    Caption = 'Recurring Expense Card';
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; rec."Recurring Id") { ApplicationArea = All; Editable = false; }
                field("Category Code"; rec."Category Code") { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Cycle; rec.Cycle) { ApplicationArea = All; }
                field("Start Date"; rec."Start Date") { ApplicationArea = All; }
                field("Next Cycle Date"; rec."Next Cycle Date") { ApplicationArea = All; Editable = false; }
            }
        }
    }
}
