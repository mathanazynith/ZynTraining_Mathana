report 50143 "Export Income Report"
{
    Caption = 'Export Income Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    

   dataset
    {
        dataitem(Income; "ZYN_IncomeTracker")
        {
            DataItemTableView = sorting("Income Id");
 
            
            RequestFilterFields = Incategory, "date";
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(CategoryName; CategoryName)
                {
                    ApplicationArea = All;
                    Caption = 'Category';
                    TableRelation  = "ZYN_Income Category".Name;


                    
                    
                }

                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                }

                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                }
            }
        }
    }

    var
        CategoryName: Code[100];
        StartDate: Date;
        EndDate: Date;
        trigger OnPostReport()
    var
        Income: Record "ZYN_IncomeTracker";
        ExcelBuf:Record "Excel Buffer" temporary;
        TotalAmount: Decimal;
    begin
        Clear(ExcelBuf);
        TotalAmount := 0;
 
        ExcelBuf.AddColumn('Income Id.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
 
        
        if CategoryName <> '' then
            Income.SetRange(InCategory, CategoryName);
 
        if (StartDate <> 0D) and (EndDate <> 0D) then
            Income.SetRange("date", StartDate, EndDate);
 
        
        if Income.FindSet() then
            repeat
                ExcelBuf.AddColumn(Income."Income Id", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Income.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Income.Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(Income.date, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                ExcelBuf.AddColumn(Income.InCategory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                 ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.NewRow;
                TotalAmount += Income.Amount
            until Income.Next() = 0;
            ExcelBuf.NewRow;
    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
    ExcelBuf.AddColumn('TOTAL', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    ExcelBuf.AddColumn(TotalAmount, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
 
 
        
        ExcelBuf.CreateNewBook('Expense Report');
        ExcelBuf.WriteSheet('Expenses', CompanyName, UserId);
        ExcelBuf.CloseBook;
        ExcelBuf.SetFriendlyFilename('Expense Report.xlsx');
        ExcelBuf.OpenExcel;
    end;
}
 
