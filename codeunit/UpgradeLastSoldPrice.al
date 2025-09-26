codeunit 50140 "Upgrade Last Sold Price"
{
    Subtype = Upgrade;
    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
        TagId: Label 'LAST_SOLD_PRICE_INIT_V6', Locked = true;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        LastSoldPrice: Record "ZYN_Last Sold Price";
        HighestPrice: Decimal;
        HighestItemNo: Code[20];
        EntryNo: Integer;
    begin
        if UpgradeTag.HasUpgradeTag(TagId) then
            exit;
        LastSoldPrice.SetCurrentKey("entryNo");
        if LastSoldPrice.FindLast() then
            EntryNo := LastSoldPrice."entryNo"
        else
            EntryNo := 0;
        SalesInvHeader.Reset();
        if SalesInvHeader.FindSet() then
            repeat
                if SalesInvHeader."Sell-to Customer No." = '' then
                    continue;
                HighestPrice := 0;
                HighestItemNo := '';
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                if SalesInvLine.FindSet() then
                    repeat
                        if SalesInvLine."Unit Price" > HighestPrice then begin
                            HighestPrice := SalesInvLine."Unit Price";
                            HighestItemNo := SalesInvLine."No.";
                        end;
                    until SalesInvLine.Next() = 0;
                if HighestPrice <= 0 then
                    continue;
                if LastSoldPrice.Get(SalesInvHeader."Sell-to Customer No.", HighestItemNo) then begin
                    if (SalesInvHeader."Posting Date" > LastSoldPrice."Posting Date") or (HighestPrice > LastSoldPrice."Item Price") then begin
                        LastSoldPrice.Validate("Item Price", HighestPrice);
                        LastSoldPrice.Validate("Posting Date", SalesInvHeader."Posting Date");
                        LastSoldPrice.Modify();
                    end;
                end else begin
                    EntryNo += 1;
                    LastSoldPrice.Init();
                    LastSoldPrice.Validate("entryNo", EntryNo);
                    LastSoldPrice.Validate("Customer No.", SalesInvHeader."Sell-to Customer No.");
                    LastSoldPrice.Validate("Item No.", HighestItemNo);
                    LastSoldPrice.Validate("Item Price", HighestPrice);
                    LastSoldPrice.Validate("Posting Date", SalesInvHeader."Posting Date");
                    LastSoldPrice.Insert();
                end;
            until SalesInvHeader.Next() = 0;
        UpgradeTag.SetUpgradeTag(TagId);
    end;
}
