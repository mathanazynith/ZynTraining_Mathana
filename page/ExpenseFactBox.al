page 50149 "ExpenseCategoryFactBox"
{
    PageType = CardPart;
    SourceTable = "Expense Category";
    Caption = 'Expense Summary';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup("Expense Summary")
            {
                Caption = 'Expense Summary';

                field(Monthly; Monthly)
                {
                    ApplicationArea = All;
                    Caption = 'This Month';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ExpenseList: Page "Expense Tracker List";
                        Expense: Record "Expense Tracker";
                    begin
                        SetMonthlyFilter(Expense);
                        ExpenseList.SetTableView(Expense);
                        ExpenseList.Run();
                    end;
                }

                field(Quarterly; Quarterly)
                {
                    ApplicationArea = All;
                    Caption = 'This Quarter';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ExpenseList: Page "Expense Tracker List";
                        Expense: Record "Expense Tracker";
                    begin
                        SetQuarterlyFilter(Expense);
                        ExpenseList.SetTableView(Expense);
                        ExpenseList.Run();
                    end;
                }

                field(HalfYearly; HalfYearly)
                {
                    ApplicationArea = All;
                    Caption = 'This Half Year';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ExpenseList: Page "Expense Tracker List";
                        Expense: Record "Expense Tracker";
                    begin
                        SetHalfYearlyFilter(Expense);
                        ExpenseList.SetTableView(Expense);
                        ExpenseList.Run();
                    end;
                }

                field(Yearly; Yearly)
                {
                    ApplicationArea = All;
                    Caption = 'This Year';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        ExpenseList: Page "Expense Tracker List";
                        Expense: Record "Expense Tracker";
                    begin
                        SetYearlyFilter(Expense);
                        ExpenseList.SetTableView(Expense);
                        ExpenseList.Run();
                    end;
                }
            }
        }
    }

    var
        Monthly: Decimal;
        Quarterly: Decimal;
        HalfYearly: Decimal;
        Yearly: Decimal;

    trigger OnAfterGetRecord()
    begin
        Monthly := CalcTotalAmount('MONTHLY');
        Quarterly := CalcTotalAmount('QUARTERLY');
        HalfYearly := CalcTotalAmount('HALFYEARLY');
        Yearly := CalcTotalAmount('YEARLY');
    end;

    
    local procedure CalcTotalAmount(Period: Code[20]): Decimal
    var
        Expense: Record "Expense Tracker";
        Total: Decimal;
    begin
        case Period of
            'MONTHLY':
                SetMonthlyFilter(Expense);
            'QUARTERLY':
                SetQuarterlyFilter(Expense);
            'HALFYEARLY':
                SetHalfYearlyFilter(Expense);
            'YEARLY':
                SetYearlyFilter(Expense);
        end;

        if Expense.FindSet() then
            repeat
                Total += Expense.Amount;
            until Expense.Next() = 0;

        exit(Total);
    end;


    local procedure SetMonthlyFilter(var Expense: Record "Expense Tracker")
    var
        StartDate: Date;
        EndDate: Date;
        SelectedMonth: Integer;
        CurrentYear: Integer;
    begin
        SelectedMonth := DATE2DMY(WORKDATE, 2);
        CurrentYear := DATE2DMY(WORKDATE, 3);
        StartDate := CalcDate('<-CM>', WorkDate());
        EndDate := CALCDATE('<CM>', WorkDate());

        Expense.Reset();
        Expense.SetRange("Category", Rec.Name);
        Expense.SetRange("Date", StartDate, EndDate);
    end;

    local procedure SetQuarterlyFilter(var Expense: Record "Expense Tracker")
    var
        StartDate: Date;
        EndDate: Date;
        SelectedMonth: Integer;
        CurrentYear: Integer;
    begin
        CurrentYear := DATE2DMY(WORKDATE, 3);
        SelectedMonth := DATE2DMY(WORKDATE, 2);

        
       StartDate := CalcDate('<-CQ>', WorkDate());

        EndDate := CALCDATE('<CQ>', WorkDate());

        Expense.Reset();
        Expense.SetRange("Category", Rec.Name);
        Expense.SetRange("Date", StartDate, EndDate);
    end;

    local procedure SetHalfYearlyFilter(var Expense: Record "Expense Tracker")
var
    StartDate: Date;
    EndDate: Date;
begin
    
    StartDate := CalcDate('<-CY>', WorkDate());  
    if DATE2DMY(WorkDate(), 2) > 6 then
        StartDate := CalcDate('<+6M>', StartDate);


    EndDate := CalcDate('<+6M-1D>', StartDate);

    Expense.Reset();
    Expense.SetRange("Category", Rec.Name);
    Expense.SetRange("Date", StartDate, EndDate);
end;


    local procedure SetYearlyFilter(var Expense: Record "Expense Tracker")
    var
        StartDate: Date;
        EndDate: Date;
        CurrentYear: Integer;
    begin
        CurrentYear := DATE2DMY(WORKDATE, 3);
        StartDate := CalcDate('<-CY>', WorkDate());
        EndDate := CalcDate('<CY>,', WorkDate());

        Expense.Reset();
        Expense.SetRange("Category", Rec.Name);
        Expense.SetRange("Date", StartDate, EndDate);
    end;
}
