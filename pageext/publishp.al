pageextension 50105 CustomerpageExtension extends "Customer Card"
{  trigger OnOpenPage()
begin
    if rec."No."=''then
    IsNewCustomer := true;
end; 
trigger OnQueryClosePage(CloseAction: Action): Boolean  
begin
    if IsNewCustomer and (Rec.Name='') then begin
        Message('please enter the value'); 
                   
            exit(false);
        end;
             
        end;

    trigger OnClosePage()
    var
        Publisher: Codeunit CustomerEventPublisher;
    begin
        
        if StrLen(Rec."No.") > 0 then
            if CopyStr(Rec."No.", 1, 1) <> '{' then
                Publisher.OnCustomerCreated(Rec."No.", Rec.Name);
    end;
    var
        IsNewCustomer: Boolean;
    
}
pageextension 50133 CopyCustomerToOtherCompany extends "Customer Card"
{
    var
        IsNewCustomer: Boolean;
 
    trigger OnOpenPage()
    begin
        if Rec."No." = '' then
            IsNewCustomer := true;
    end;
 
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if IsNewCustomer and (Rec.Name = '') then begin
            Message('Please enter a customer name before closing the page.');
            exit(false); 
        end;
 
        exit(true); 
    end;
 
    trigger OnClosePage()
    var
        Publisher: Codeunit CompanyChangePublisher;
    begin
        if IsNewCustomer and (Rec.Name <> '') then
            Publisher.OnCompanyCreated(Rec);
    end;
}
