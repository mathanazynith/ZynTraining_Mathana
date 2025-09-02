codeunit 50123 "Loyalty Points Handler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure CheckLoyaltyPointsBeforePosting(var SalesHeader: Record "Sales Header")
    var
        CustomerRec: Record Customer;
    begin
        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice ,  SalesHeader."Document Type"::order]) then
        begin
               
        if CustomerRec.Get(SalesHeader."Sell-to Customer No.") then
        begin
            if CustomerRec."Loyalty Points Used" >= CustomerRec."Loyalty Points Allowed" then
                Error('Customer "%1" has exceeded the allowed loyalty points. Invoice cannot be posted.', CustomerRec.Name);
        end;
        end;
    end;
 
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure AddLoyaltyPointsAfterPosting(var Salesheader: Record "Sales Header")
    var
        CustomerRec: Record Customer;                                                          
    begin
        if (SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice ,  SalesHeader."Document Type"::order]) then
        begin
        if CustomerRec.Get(Salesheader."Sell-to Customer No.") then
        begin
            CustomerRec."Loyalty Points Used" += 10;
            CustomerRec.Modify();
        end;
        end;
    end;
}