page 50151 "RemainingBudgetFactBox"
{
    PageType = CardPart;
    SourceTable = "Expense Category";
    ApplicationArea = All;
    Caption = 'Remaining Budget';

    layout
    {
        area(content)
        {
            field("Remaining Budget"; RemainingBudget)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    var
        RemainingBudget: Decimal;

    trigger OnAfterGetRecord()
    var
        BudgetAmt: Decimal;
        ExpenseAmt: Decimal;
        WorkDt: Date;
        FirstDay: Date;
        LastDay: Date;
        m: Integer;
        y: Integer;
        BudgetRec: Record "Budget Tracker";
        ExpenseRec: Record "Expense Tracker";
    begin
        WorkDt := WorkDate();
        m := Date2DMY(WorkDt, 2);
        y := Date2DMY(WorkDt, 3);
        FirstDay := DMY2Date(1, m, y);
        LastDay := CalcDate('<CM>', FirstDay);

        
        BudgetRec.SetRange("Expense Category", Rec.Name);
        BudgetRec.SetRange("From Date", FirstDay);
        BudgetRec.SetRange("To Date", LastDay);
        if BudgetRec.FindFirst() then
            BudgetAmt := BudgetRec.Amount;

        
        ExpenseRec.SetRange("Category", Rec.Name);
        ExpenseRec.SetRange("Date", FirstDay, LastDay);
        if ExpenseRec.FindSet() then
            ExpenseRec.CalcSums(Amount);
        ExpenseAmt := ExpenseRec.Amount;

    
        RemainingBudget := BudgetAmt - ExpenseAmt;
    end;
}
