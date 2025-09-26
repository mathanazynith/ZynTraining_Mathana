report 50107 "Sales Order Posting Date"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Update Sales Order Posting Date';
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order),status=const(open));

            trigger OnAfterGetRecord()
            var
                OrdersModified: Integer;
            begin
                if SalesHeader."Posting Date" <> NewPostingDate then begin
                    SalesHeader."Posting Date" := NewPostingDate;
                    SalesHeader.Modify(true);
                    OrdersChangedCount += 1;
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group("Options")
                {
                    field(NewPostingDate; NewPostingDate)
                    {
                        ApplicationArea = All;
                        Caption = 'New Posting Date';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Message('%1 Sales Orders were updated with new Posting Date: %2',
            OrdersChangedCount, Format(NewPostingDate));
    end;

    var
        NewPostingDate: Date;
        OrdersChangedCount: Integer;
}
