page 50235 "Recurring Invoice FactBox"
{
    PageType = CardPart;
    SourceTable = "Sales Header";
    Caption = 'Recurring Invoice Stats';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(RecurringInvoices)
            {
                Caption = 'Recurring Invoices';

                field(MonthlyRecurringAmount; MonthlyAmount)
                {
                    ApplicationArea = All;
                    Caption = 'This Month Amount';
                    DrillDownPageId = "Sales Invoice List";

                    trigger OnDrillDown()
                    var
                        SalesInv: Record "Sales Header";
                        StartDate: Date;
                        EndDate: Date;
                    begin
                        StartDate := DMY2Date(1, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3));
                        EndDate := CalcDate('<CM>', StartDate);

                        SalesInv.SetRange("Document Type", SalesInv."Document Type"::Invoice);
                        SalesInv.SetRange("From Subscription", true);
                        SalesInv.SetRange("Posting Date", StartDate, EndDate);

                        PAGE.Run(PAGE::"Sales Invoice List", SalesInv);
                    end;
                }
            }
        }
    }

    var
        MonthlyAmount: Decimal;

    trigger OnOpenPage()
    begin
        CalculateMonthlyAmount();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateMonthlyAmount();
    end;

    local procedure CalculateMonthlyAmount()
    var
        SalesInv: Record "Sales Header";
        SalesLine: Record "Sales Line";
        StartDate: Date;
        EndDate: Date;
    begin
        Clear(MonthlyAmount);

        StartDate := DMY2Date(1, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3));
        EndDate := CalcDate('<CM>', StartDate);

        SalesInv.SetRange("Document Type", SalesInv."Document Type"::Invoice);
        SalesInv.SetRange("From Subscription", true);
        SalesInv.SetRange("Posting Date", StartDate, EndDate);

        if SalesInv.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
                SalesLine.SetRange("Document No.", SalesInv."No.");

                if SalesLine.FindSet() then
                    repeat
                        MonthlyAmount += SalesLine."Line Amount";
                    until SalesLine.Next() = 0;
            until SalesInv.Next() = 0;
    end;
}
