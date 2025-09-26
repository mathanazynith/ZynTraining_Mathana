pageextension 50100 ContacListExt extends "Contact List"

{
    actions
    {
        addlast(processing)
        {
            group(CustomFilters)
            {
                Caption = 'Filter Contacts';
                action(FilterCustomers)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    Image = Customer;
                    trigger OnAction()
                    var
                        BusinessRelationEnum: Enum "Contact Business Relation";
                    begin
                        BusinessRelationEnum := BusinessRelationEnum::Customer;
                        Rec.SetRange("Contact Business Relation", BusinessRelationEnum);
                        CurrPage.Update(false);
                    end;
                }
                action(FilterVendors)
                {
                    ApplicationArea = All;
                    Caption = 'Vendors';
                    Image = Vendor;
                    trigger OnAction()
                    var
                        BusinessRelationEnum: Enum "Contact Business Relation";
                    begin
                        BusinessRelationEnum := BusinessRelationEnum::Vendor;
                        Rec.SetRange("Contact Business Relation", BusinessRelationEnum);
                        CurrPage.Update(false);
                    end;
                }
                action(FilterBankAccounts)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Accounts';
                    Image = Bank;
                    trigger OnAction()
                    var
                        BusinessRelationEnum: Enum "Contact Business Relation";
                    begin
                        BusinessRelationEnum := BusinessRelationEnum::"Bank Account";
                        Rec.SetRange("Contact Business Relation", BusinessRelationEnum);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
}