page 50157 "Budget Tracker Card"
{
    PageType = Card;
    SourceTable = "Budget Tracker";
    Caption = 'BudgetTracker';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Budget Id";rec. "Budget Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("From Date"; rec."From Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Date"; rec."To Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expense Category"; rec."Expense Category")
                {
                    ApplicationArea = All;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

   trigger OnNewRecord(BelowxRec: Boolean)
    var
        WorkDt: Date;
        FirstDay: Date;
        LastDay: Date;
        CurrentMonth: Integer;
        CurrentYear: Integer;
    begin
        WorkDt := WorkDate();
        CurrentMonth := Date2DMY(WorkDt, 2);
        CurrentYear := Date2DMY(WorkDt, 3);

        FirstDay := DMY2Date(1, CurrentMonth, CurrentYear);
        LastDay := CalcDate('<CM>', FirstDay);

        Rec."From Date" := FirstDay;
        Rec."To Date" := LastDay;
    end;
}