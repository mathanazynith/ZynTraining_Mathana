codeunit 50113 CustomerFieldValidator
{
    
}
codeunit 50111 CustomerAddNotifier
{
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure NotifyCustomerAdded(var Rec: Record Customer)
    begin
        Message('Customer added: %1 (No: %2)', Rec.Name, Rec."No.");
    end;
}
