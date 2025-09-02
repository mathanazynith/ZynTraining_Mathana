page 50109 "IncomeCategoryFactBox"
{
    PageType = CardPart;
    SourceTable = "Income Category";
    Caption = 'Income Summary';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup("Income Summary")
            {
                Caption = 'Income Summary';

                field(Monthly; Monthly)
                {
                    ApplicationArea = All;
                    Caption = 'This Month';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        IncomeList: Page "Income Tracker List";
                        Income: Record "IncomeTracker";
                    begin
                        SetMonthlyFilter(Income);
                        IncomeList.SetTableView(Income);
                        IncomeList.Run();
                    end;
                }

                field(Quarterly; Quarterly)
                {
                    ApplicationArea = All;
                    Caption = 'This Quarter';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        IncomeList: Page "Income Tracker List";
                        Income: Record "IncomeTracker";
                    begin
                        SetQuarterlyFilter(Income);
                        IncomeList.SetTableView(Income);
                        IncomeList.Run();
                    end;
                }

                field(HalfYearly; HalfYearly)
                {
                    ApplicationArea = All;
                    Caption = 'This Half Year';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        IncomeList: Page "Income Tracker List";
                        Income: Record "IncomeTracker";
                    begin
                        SetHalfYearlyFilter(Income);
                        IncomeList.SetTableView(Income);
                        IncomeList.Run();
                    end;
                }

                field(Yearly; Yearly)
                {
                    ApplicationArea = All;
                    Caption = 'This Year';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        IncomeList: Page "Income Tracker List";
                        Income: Record "IncomeTracker";
                    begin
                        SetYearlyFilter(Income);
                        IncomeList.SetTableView(Income);
                        IncomeList.Run();
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
        Income: Record "IncomeTracker";
        Total: Decimal;
    begin
        case Period of
            'MONTHLY':
                SetMonthlyFilter(Income);
            'QUARTERLY':
                SetQuarterlyFilter(Income);
            'HALFYEARLY':
                SetHalfYearlyFilter(Income);
            'YEARLY':
                SetYearlyFilter(Income);
        end;

        if Income.FindSet() then
            repeat
                Total += Income.Amount;
            until Income.Next() = 0;

        exit(Total);
    end;


    local procedure SetMonthlyFilter(var Income: Record "IncomeTracker")
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

        Income.Reset();
        Income.SetRange("InCategory", Rec.Name);
        Income.SetRange("Date", StartDate, EndDate);
    end;

    local procedure SetQuarterlyFilter(var Income: Record "IncomeTracker")
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

        Income.Reset();
        Income.SetRange("InCategory", Rec.Name);
        Income.SetRange("Date", StartDate, EndDate);
    end;

    local procedure SetHalfYearlyFilter(var Income: Record "IncomeTracker")
var
    StartDate: Date;
    EndDate: Date;
begin
    
    StartDate := CalcDate('<-CY>', WorkDate());  
    if DATE2DMY(WorkDate(), 2) > 6 then
        StartDate := CalcDate('<+6M>', StartDate);


    EndDate := CalcDate('<+6M-1D>', StartDate);

    Income.Reset();
    Income.SetRange("InCategory", Rec.Name);
    Income.SetRange("Date", StartDate, EndDate);
end;


    local procedure SetYearlyFilter(var Income: Record "IncomeTracker")
    var
        StartDate: Date;
        EndDate: Date;
        CurrentYear: Integer;
    begin
        CurrentYear := DATE2DMY(WORKDATE, 3);
        StartDate := CalcDate('<-CY>', WorkDate());
        EndDate := CalcDate('<CY>,', WorkDate());

        Income.Reset();
        Income.SetRange("InCategory", Rec.Name);
        Income.SetRange("Date", StartDate, EndDate);
    end;
}
