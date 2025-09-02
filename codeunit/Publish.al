codeunit 50110 CustomerEventPublisher
{
    [IntegrationEvent(false, false)]
    procedure OnCustomerCreated(CustomerNo: Code[20]; CustomerName: Text[100])
    begin
    end;
}
