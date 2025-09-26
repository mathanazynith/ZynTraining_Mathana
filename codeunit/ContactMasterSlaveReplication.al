codeunit 50272 "ZYN_ContactReplication"
{
    Subtype = Normal;

    var
        IsSyncing: Boolean;
        IsSlaveContactCreation: Boolean;
        IsSlaveContactModification: Boolean;

    procedure StartSlaveContactCreation()
    begin
        IsSlaveContactCreation := true;
        IsSlaveContactModification := true;
    end;

    procedure EndSlaveContactCreation()
    begin
        IsSlaveContactCreation := false;
        IsSlaveContactModification := false;
    end;

    // Prevent Contact creation in slave company
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInsertEvent', '', true, true)]
    local procedure ContactOnBeforeInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') and (not IsSlaveContactCreation) then
                Error(CreateContactInSlaveErr);
    end;

    // Prevent Contact deletion in slave and check open/released documents
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure ContactOnBeforeDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        SlaveCompany: Record ZYN_CustomCompany;
        SlaveSales: Record "Sales Header";
        SlavePurch: Record "Purchase Header";
    begin
        if not ZynCompany.Get(COMPANYNAME) then
            exit;

        // Prevent deletion in slave companies directly
        if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
            Error(DeleteContactInSlaveErr);

        // Check open or released documents in master company
        SalesHeader.SetRange("Bill-to Contact No.", Rec."No.");
        if SalesHeader.FindFirst() then
            if (SalesHeader.Status in [SalesHeader.Status::Open, SalesHeader.Status::Released]) then
                Error(OpenSalesMasterErr);

        PurchHeader.SetRange("Buy-from Contact No.", Rec."No.");
        if PurchHeader.FindFirst() then
            if (PurchHeader.Status in [PurchHeader.Status::Open, PurchHeader.Status::Released]) then
                Error(OpenPurchMasterErr);

        // Check open or released documents in slave companies
        if ZynCompany."Is Master" then begin
            SlaveCompany.Reset();
            SlaveCompany.SetRange("Master Company Name", ZynCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    // Sales in slave
                    SlaveSales.ChangeCompany(SlaveCompany.Name);
                    SlaveSales.SetRange("Bill-to Contact No.", Rec."No.");
                    if SlaveSales.FindFirst() then
                        if (SlaveSales.Status in [SlaveSales.Status::Open, SlaveSales.Status::Released]) then
                            Error(OpenSalesSlaveErr, SlaveCompany.Name);

                    // Purchase in slave
                    SlavePurch.ChangeCompany(SlaveCompany.Name);
                    SlavePurch.SetRange("Buy-from Contact No.", Rec."No.");
                    if SlavePurch.FindFirst() then
                        if (SlavePurch.Status in [SlavePurch.Status::Open, SlavePurch.Status::Released]) then
                            Error(OpenPurchSlaveErr, SlaveCompany.Name);
                until SlaveCompany.Next() = 0;
        end;
    end;

    // Replicate deletion to slave companies after master deletion
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterDeleteEvent', '', true, true)]
    local procedure ContactOnAfterDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
        SlaveCompany: Record ZYN_CustomCompany;
        SlaveContact: Record Contact;
    begin
        if IsSyncing then
            exit;

        if not ZynCompany.Get(COMPANYNAME) then
            exit;

        IsSyncing := true;

        if ZynCompany."Is Master" then begin
            // Delete relations + customer/vendor in Master
            DeleteRelationsAndCustomerVendor(Rec, COMPANYNAME);

            // Replicate to slave companies
            SlaveCompany.Reset();
            SlaveCompany.SetRange("Master Company Name", ZynCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    SlaveContact.ChangeCompany(SlaveCompany.Name);
                    if SlaveContact.Get(Rec."No.") then begin
                        DeleteRelationsAndCustomerVendor(SlaveContact, SlaveCompany.Name);
                        SlaveContact.Delete(false);
                    end;
                until SlaveCompany.Next() = 0;
        end;

        IsSyncing := false;
    end;

    // Helper procedure: delete relations + customer/vendor
    local procedure DeleteRelationsAndCustomerVendor(var Contact: Record Contact; CompanyName: Text)
    var
        ContBusRel: Record "Contact Business Relation";
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        ContBusRel.ChangeCompany(CompanyName);
        ContBusRel.SetRange("Contact No.", Contact."No.");
        if ContBusRel.FindSet() then
            repeat
                case ContBusRel."Link to Table" of
                    ContBusRel."Link to Table"::Customer:
                        begin
                            Customer.ChangeCompany(CompanyName);
                            if Customer.Get(ContBusRel."No.") then
                                Customer.Delete(false);
                        end;
                    ContBusRel."Link to Table"::Vendor:
                        begin
                            Vendor.ChangeCompany(CompanyName);
                            if Vendor.Get(ContBusRel."No.") then
                                Vendor.Delete(false);
                        end;
                end;
                ContBusRel.Delete(false);
            until ContBusRel.Next() = 0;
    end;

    // Replicate Contact insert from Master → Slaves
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    local procedure ContactOnAfterInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_CustomCompany;
        SlaveCompany: Record ZYN_CustomCompany;
        NewContact: Record Contact;
    begin
        if IsSyncing then
            exit;
        IsSyncing := true;

        if MasterCompany.Get(COMPANYNAME) then begin
            if MasterCompany."Is Master" then begin
                SlaveCompany.Reset();
                SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
                if SlaveCompany.FindSet() then
                    repeat
                        NewContact.ChangeCompany(SlaveCompany.Name);
                        if not NewContact.Get(Rec."No.") then begin
                            NewContact.Init();
                            NewContact.TransferFields(Rec, true);
                            NewContact.Insert(true);
                        end;
                    until SlaveCompany.Next() = 0;
            end;
        end;

        IsSyncing := false;
    end;

    // Replicate Contact modification from Master → Slaves
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    local procedure ContactOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_CustomCompany;
        SlaveCompany: Record ZYN_CustomCompany;
        SlaveContact: Record Contact;
        MasterRef: RecordRef;
        SlaveRef: RecordRef;
        Field: FieldRef;
        SlaveField: FieldRef;
        i: Integer;
        IsDifferent: Boolean;
    begin
        if IsSyncing then
            exit;

        if MasterCompany.Get(COMPANYNAME) then begin
            if MasterCompany."Is Master" then begin
                SlaveCompany.Reset();
                SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
                if SlaveCompany.FindSet() then
                    repeat
                        SlaveContact.ChangeCompany(SlaveCompany.Name);
                        if SlaveContact.Get(Rec."No.") then begin
                            MasterRef.GetTable(Rec);
                            SlaveRef.GetTable(SlaveContact);
                            IsDifferent := false;

                            for i := 1 to MasterRef.FieldCount do begin
                                Field := MasterRef.FieldIndex(i);
                                if Field.Class <> FieldClass::Normal then
                                    continue;
                                if Field.Number in [1] then
                                    continue;
                                SlaveField := SlaveRef.Field(Field.Number);
                                if SlaveField.Value <> Field.Value then begin
                                    IsDifferent := true;
                                    break;
                                end;
                            end;

                            if IsDifferent then begin
                                IsSyncing := true;
                                SlaveContact.TransferFields(Rec, false);
                                SlaveContact."No." := Rec."No.";
                                SlaveContact.Modify(true);
                                IsSyncing := false;
                            end;
                        end;
                    until SlaveCompany.Next() = 0;
            end;
            if (not MasterCompany."Is Master") and (MasterCompany."Master Company Name" <> '') then begin
                if (UserId = '') or (UserId = 'NT AUTHORITY\SYSTEM') then
                    exit;
                if not RunTrigger then
                    exit;
                Error(ModifyContactInSlaveErr);
            end;
        end;
    end;

    var
        CreateContactInSlaveErr: Label 'You cannot create contacts in a slave company. Create the contact in the master company only.';
        ModifyContactInSlaveErr: Label 'You cannot modify contacts in a slave company. Modify contacts only in the master company.';
        DeleteContactInSlaveErr: Label 'You cannot delete contacts in a slave company. Delete contacts only in the master company.';
        OpenSalesMasterErr: Label 'Cannot delete contact. Open/Released Sales Invoice exists in master company.';
        OpenSalesSlaveErr: Label 'Cannot delete contact. Open/Released Sales Invoice exists in slave company %1.';
        OpenPurchMasterErr: Label 'Cannot delete contact. Open/Released Purchase Invoice exists in master company.';
        OpenPurchSlaveErr: Label 'Cannot delete contact. Open/Released Purchase Invoice exists in slave company %1.';
}
