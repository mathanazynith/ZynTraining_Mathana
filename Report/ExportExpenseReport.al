report 50141 "Export Expense Report"
{
    Caption = 'Export Expense Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    

   dataset
    {
        dataitem(Expense; "ZYN_Expense Tracker")
        {
            DataItemTableView = sorting("Expense Id");
 
           
            RequestFilterFields = category, "date";
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
                    TableRelation  = "ZYN_Expense Category".Name;


                    
                    
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
        Expense: Record "ZYN_Expense Tracker";
        ExcelBuf:Record "Excel Buffer" temporary;
        TotalAmount: Decimal;
    begin
        Clear(ExcelBuf);
        TotalAmount := 0;
 
        
        ExcelBuf.AddColumn('Expense Id.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn('Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
 
        
        if CategoryName <> '' then
            Expense.SetRange(Category, CategoryName);
 
        if (StartDate <> 0D) and (EndDate <> 0D) then
            Expense.SetRange("date", StartDate, EndDate);
 
        if Expense.FindSet() then
            repeat
                ExcelBuf.AddColumn(Expense."Expense Id", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Expense.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                ExcelBuf.AddColumn(Format(Expense.Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.AddColumn(Expense.date, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                ExcelBuf.AddColumn(Expense.Category, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                 ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                ExcelBuf.NewRow;
                TotalAmount += Expense.Amount
            until Expense.Next() = 0;
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
 
