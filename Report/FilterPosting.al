report 50110 "Bulk Sales invoice Posting"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Bulk Sales Order Posting';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sale Header"; "Sales Header")
        {
             DataItemTableView = where("Document Type" = const(invoice));
           

            trigger OnAfterGetRecord()
            var
                SalesPost: Codeunit "Sales-Post";
            begin
                SalesPost.Run("Sale Header"); 
            end;
        }
    }
}
