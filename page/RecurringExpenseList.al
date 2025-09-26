page 50161 "ZYN_Recurring Expense List"
{
    PageType = List;
    SourceTable = "ZYN_Recurring Expense";
    ApplicationArea = All;
    Caption = 'Recurring Expense List';
    UsageCategory = Lists;
    CardPageId = "ZYN_Recurring Expense Card"; 

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; rec."Recurring Id") { ApplicationArea = All; }
                field("Category Code"; rec."Category Code") { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
                field(Cycle; rec.Cycle) { ApplicationArea = All; }
                field("Start Date"; rec."Start Date") { ApplicationArea = All; }
                field("Next Cycle Date"; rec."Next Cycle Date") { ApplicationArea = All; }
            }
        }
    }
}
