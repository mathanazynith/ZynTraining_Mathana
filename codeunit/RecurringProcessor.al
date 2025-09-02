codeunit 50160 "Recurring Expense Processor"
{
    Subtype = Normal;

    trigger OnRun()
    var
        Recurring: Record "Recurring Expense";
        ExpenseTracker: Record "Expense Tracker";
        WorkDt: Date;
        NewExpenseId: Code[20];
        nextDate: Date;
        LastExpense: Record "Expense Tracker";
        LastId: Integer;
    begin   
        WorkDt := WorkDate();

        Recurring.Reset();
        Recurring.SetRange("Next Cycle Date", WorkDt);
        if Recurring.FindSet() then
            repeat
                
                if LastExpense.FindLast() then
                    Evaluate(LastId, CopyStr(LastExpense."Expense Id", 4)) 
                else
                    LastId := 0;

                LastId += 1;
                NewExpenseId := 'EXP' + PadStr(Format(LastId), 4, '0');
            
                ExpenseTracker.Init();
                ExpenseTracker."Expense Id" := NewExpenseId;
                ExpenseTracker."Category" := Recurring."Category Code";
                ExpenseTracker.Description := Recurring."Category Code";
                ExpenseTracker.Amount := Recurring.Amount;
                ExpenseTracker.Date := Recurring."Next Cycle Date";  
                ExpenseTracker.Insert(true);

                
                case Recurring.Cycle of
                    Recurring.Cycle::Weekly:
                        nextDate := CalcDate('+1W', Recurring."Next Cycle Date");
                    Recurring.Cycle::Monthly:
                        nextDate := CalcDate('+1M', Recurring."Next Cycle Date");
                    Recurring.Cycle::Quarterly:
                        nextDate := CalcDate('+3M', Recurring."Next Cycle Date");
                    Recurring.Cycle::"Half Yearly":
                        nextDate := CalcDate('+6M', Recurring."Next Cycle Date");
                    Recurring.Cycle::Yearly:
                        nextDate := CalcDate('+1Y', Recurring."Next Cycle Date");
                end;

                Recurring."Next Cycle Date" := nextDate;
                Recurring.Modify();

            until Recurring.Next() = 0;
    end;
}
