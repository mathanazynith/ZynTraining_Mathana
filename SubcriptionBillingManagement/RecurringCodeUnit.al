codeunit 50350 "Recurring Invoice Processor"
{
    Subtype = Normal;

    trigger OnRun()
    begin
        CreateRecurringInvoices();
    end;

    local procedure CreateRecurringInvoices()
    var
        RecInv: Record "Recurring Sales Invoice";
        SubRec: Record Subscription;
        PlanRec: Record "Monthly Subscription Plan";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        AmountToUse: Decimal;
    begin
        SalesSetup.Get();

        RecInv.Reset();
        if RecInv.FindSet() then
            repeat
                if SubRec.Get(RecInv."Subscription ID") then begin
                    
                    if SubRec."Next Billing Date" = WorkDate() then begin

                        
                        if not PlanRec.Get(SubRec."Plan ID") then
                            continue;

                      
                        NewNo := NoSeriesMgt.GetNextNo(SalesSetup."Invoice Nos.", WorkDate(), true);

                     
                        SalesHeader.Init();
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader."No." := NewNo;
                        SalesHeader.Validate("Sell-to Customer No.", SubRec."Subscriber ID");
                        SalesHeader."Posting Date" := WorkDate();
                        SalesHeader."Document Date" := WorkDate();

                        
                        SalesHeader."From Subscription" := true;

                        SalesHeader.Insert(true);

                        
                        AmountToUse := RecInv."Plan Amount";
                        if AmountToUse = 0 then
                            AmountToUse := PlanRec.Fees;

                       
                        SalesLine.Init();
                        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := 10000;
                        SalesLine.Type := SalesLine.Type::"G/L Account";
                        SalesLine.Validate(Quantity, 1);
                        SalesLine.Validate("Unit Price", AmountToUse);
                        SalesLine.Insert(true);

                       
                        SubRec."Next Billing Date" := CalcDate('<1M>', SubRec."Next Billing Date");
                        SubRec.Modify(true);
                    end;
                end;
            until RecInv.Next() = 0;
    end;
}
