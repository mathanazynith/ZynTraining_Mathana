report 50152 "Export Budget vs Actual"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Export Budget vs Actual';
    ProcessingOnly = true;

    dataset { }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(Year; Year)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                    }
                }
            }
        }
    }

    var
        Year: Integer;
        Month: Integer;  
        StartDate: Date;
        EndDate: Date;
        Expense: Record "Expense Tracker";
        Budget: Record "Budget Tracker";
        Income: Record "IncomeTracker";   
        Category: Record "Expense Category";
        ExcelBuf: Record "Excel Buffer" temporary;
        Actual: Decimal;
        BudgetAmt: Decimal;
        TotalActualPerMonth: Decimal;
        TotalBudgetPerMonth: Decimal;
        TotalIncomePerMonth: Decimal;     
        SavingsPerMonth: Decimal;       
        GrandTotalActual: Decimal;
        GrandTotalBudget: Decimal;
        GrandTotalIncome: Decimal;
        GrandTotalSavings: Decimal;
        MonthNames: array[12] of Text[10];

    trigger OnPreReport()
    begin
        if Year = 0 then
            Error('Please enter a valid Year before running the report.');

        MonthNames[1] := 'Jan';
        MonthNames[2] := 'Feb';
        MonthNames[3] := 'Mar';
        MonthNames[4] := 'Apr';
        MonthNames[5] := 'May';
        MonthNames[6] := 'Jun';
        MonthNames[7] := 'Jul';
        MonthNames[8] := 'Aug';
        MonthNames[9] := 'Sep';
        MonthNames[10] := 'Oct';
        MonthNames[11] := 'Nov';
        MonthNames[12] := 'Dec';
    end;

    trigger OnPostReport()
    var
        FileName: Text;
    begin
        for Month := 1 to 12 do begin
            StartDate := DMY2DATE(1, Month, Year);
            EndDate := CalcDate('<CM>', StartDate);

            ExcelBuf.AddColumn(StrSubstNo('%1 %2', MonthNames[Month], Year), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.NewRow();

            ExcelBuf.AddColumn('Category', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Actual', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Budget', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Income', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Savings', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.NewRow();

            TotalActualPerMonth := 0;
            TotalBudgetPerMonth := 0;
            TotalIncomePerMonth := 0;

            
            Income.Reset();
            Income.SetRange("Date", StartDate, EndDate);
            if Income.FindSet() then
                repeat
                    TotalIncomePerMonth += Income.Amount;
                until Income.Next() = 0;

            
            if Category.FindSet() then
                repeat
                    Actual := 0;
                    BudgetAmt := 0;

                    
                    Expense.Reset();
                    Expense.SetRange("Category", Category.Name);
                    Expense.SetRange("Date", StartDate, EndDate);
                    if Expense.FindSet() then
                        repeat
                            Actual += Expense.Amount;
                        until Expense.Next() = 0;

                    
                    Budget.Reset();
                    Budget.SetRange("Expense Category", Category.Name);
                    Budget.SetRange("From Date", StartDate, EndDate);
                    if Budget.FindSet() then
                        repeat
                            BudgetAmt += Budget.Amount;
                        until Budget.Next() = 0;

                
                    ExcelBuf.AddColumn(Category.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(Actual, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn(BudgetAmt, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text); 
                    ExcelBuf.AddColumn('', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text); 
                    ExcelBuf.NewRow();

                    TotalActualPerMonth += Actual;
                    TotalBudgetPerMonth += BudgetAmt;

                until Category.Next() = 0;

            
            SavingsPerMonth := TotalIncomePerMonth - TotalActualPerMonth;

            
            ExcelBuf.AddColumn('TOTAL', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(TotalActualPerMonth, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(TotalBudgetPerMonth, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(TotalIncomePerMonth, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.AddColumn(SavingsPerMonth, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
            ExcelBuf.NewRow();

            ExcelBuf.NewRow();

            GrandTotalActual += TotalActualPerMonth;
            GrandTotalBudget += TotalBudgetPerMonth;
            GrandTotalIncome += TotalIncomePerMonth;
            GrandTotalSavings += SavingsPerMonth;
        end;

        
        ExcelBuf.AddColumn('GRAND TOTAL', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(GrandTotalActual, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandTotalBudget, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandTotalIncome, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(GrandTotalSavings, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);

        FileName := StrSubstNo('ExpenseBudget_Report.xlsx', Year);
        ExcelBuf.CreateNewBook('Actual vs Budget Matrix');
        ExcelBuf.WriteSheet('Report', CompanyName, UserId);
        ExcelBuf.CloseBook;
        ExcelBuf.SetFriendlyFilename(FileName);
        ExcelBuf.OpenExcel;
    end;
}
