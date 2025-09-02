codeunit 50100 PurchasePostingValidation
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure ValidateBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."Custom Approval Status" <> PurchaseHeader."Custom Approval Status" ::Approved then
            Error('Purchase Order cannot be posted unless it is approved. Current status: %1', PurchaseHeader."Custom Approval Status");
    end;
}
 