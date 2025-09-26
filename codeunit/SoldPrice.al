codeunit 50117 "ZYN_Last Sold Price Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure UpdateLastSoldPriceOnPost(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        SalesInvLine: Record "Sales Invoice Line";
        LastSoldPrice: Record "ZYN_Last Sold Price";
        HighestAmount: Decimal;
        HighestPrice: Decimal;
        HighestItemNo: Code[20];
    begin
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Document No.", SalesInvHdrNo);
        HighestPrice := 0;
        if SalesInvLine.FindSet() then
            repeat
                if SalesInvLine."Unit Price" > HighestPrice then begin
                    HighestPrice := SalesInvLine."Unit Price";
                    LastSoldPrice.Reset();
                    LastSoldPrice.SetRange("Customer No.", SalesInvLine."Sell-to Customer No.");
                    LastSoldPrice.SetRange("Item No.", salesInvline."No.");
                    if LastSoldPrice.FindFirst() then begin
                        LastSoldPrice.Validate("Item Price", HighestPrice);
                        LastSoldPrice."Posting Date" := salesInvline."Posting Date";
                        LastSoldPrice.Modify();
                    end else begin
                        LastSoldPrice.Init();
                        LastSoldPrice."Customer No." := salesinvline."Sell-to Customer No.";
                        LastSoldPrice.Validate("Item No.", salesInvline."No.");
                        LastSoldPrice.Validate("Item Price", HighestPrice);
                        LastSoldPrice."Posting Date" := salesInvline."Posting Date";
                        LastSoldPrice.Insert();
                    end;
                end;
            until salesInvline.Next() = 0;
    end;
}
