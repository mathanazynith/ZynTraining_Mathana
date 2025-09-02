codeunit 50120 CompanyChangePublisher
{
    [IntegrationEvent(false, false)]
    procedure OnCompanyCreated(Customer: Record Customer)
    begin
    end;
}


    
codeunit 50118 CompanyChangeSubscriber


{
    [EventSubscriber(ObjectType::Codeunit,codeunit::CompanyChangePublisher, 'OnCompanyCreated', '', false, false)]
    local procedure OnCustomerCreated(Customer: Record Customer)
    var
        TargetCustomer: Record Customer;
        TargetCompany: Text;
    begin
        
        TargetCompany := 'mathana';

        
        if not TargetCustomer.ChangeCompany(TargetCompany) then
            Error('Unable to access target company: %1', TargetCompany);

       
        if not TargetCustomer.Get(Customer."No.") then
         begin
          
            TargetCustomer := Customer;

            TargetCustomer.ChangeCompany(TargetCompany);

            
            TargetCustomer.Insert();
        end;
    end;
}
