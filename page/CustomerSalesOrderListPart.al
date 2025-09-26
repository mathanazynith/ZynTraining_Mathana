page 50132 "ZYN_Customer Sales Orders"
{
    PageType = ListPart;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
    Caption = 'Sales Orders';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    SalesOrderPage: Page "Sales Order";
                begin
                SalesOrderPage.SetRecord(rec);
                SalesOrderPage.run();
                end;
                }
                field("Document Date"; Rec."Document Date") { ApplicationArea = All; }
                field("Amount"; Rec.Amount) { ApplicationArea = All; }
            }
        }
    }
}
