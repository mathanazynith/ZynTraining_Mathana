pageextension 50124 SalesInvoiceListExt extends "Sales Invoice List"
{
    actions
    {
        addlast(Processing)
        {
            action("Bulk Posting")
            {
                Caption = 'Bulk Posting';
                ApplicationArea = All;
                Image = PostBatch;
                trigger OnAction()
                var
                    ReportSelection: Report "Bulk Sales Invoice Posting";
                begin
                    Report.RunModal(Report::"Bulk Sales Invoice Posting", true, true); 
                end;
            }
        }
    }
}
