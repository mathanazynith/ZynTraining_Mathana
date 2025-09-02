page 50102 "Customer Sales Invoices"
{
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Invoice));
    Caption = 'Sales Invoices';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesInvoicePage: Page "Sales Invoice";
                    begin
                        SalesInvoicePage.SetRecord(rec);
                        SalesInvoicePage.run();

                    end;
                }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Amount"; Rec.Amount) { ApplicationArea = All; }
            }
        }
    }


}
