codeunit 50272 "ZYN_ContactReplication"
{
    Subtype = Normal;

    var
        IsSyncing: Boolean;
        IsSlaveContactCreation: Boolean;
        IsSlaveContactModification: Boolean;
        SingleInstanceMgt: Codeunit "ZYN_CustomerVendorActContMgmt";
    // Slave Contact Creation Flow Control
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

    // Prevent Manual Contact Create in Slave

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeInsertEvent', '', true, true)]
    local procedure ContactOnBeforeInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') and (not IsSlaveContactCreation) then
                Error(CreateContactInSlaveErr);
    end;

    // Prevent Delete in Slave

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure ContactOnBeforeDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany, SlaveCompany : Record ZYN_CustomCompany;
        SalesHeader, PurchHeader, SlaveSales, SlavePurch : Record "Sales Header";
    begin
        if not ZynCompany.Get(COMPANYNAME) then
            exit;

        if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
            Error(DeleteContactInSlaveErr);

        // Prevent delete if open/released docs exist in master or slave
        SalesHeader.SetRange("Bill-to Contact No.", Rec."No.");
        if SalesHeader.FindFirst() and (SalesHeader.Status in [SalesHeader.Status::Open, SalesHeader.Status::Released]) then
            Error(OpenSalesMasterErr);

        PurchHeader.SetRange("Bill-to Customer No.", Rec."No.");
        if PurchHeader.FindFirst() and (PurchHeader.Status in [PurchHeader.Status::Open, PurchHeader.Status::Released]) then
            Error(OpenPurchMasterErr);

        if ZynCompany."Is Master" then begin
            SlaveCompany.Reset();
            SlaveCompany.SetRange("Master Company Name", ZynCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    SlaveSales.ChangeCompany(SlaveCompany.Name);
                    SlaveSales.SetRange("Bill-to Contact No.", Rec."No.");
                    if SlaveSales.FindFirst() and (SlaveSales.Status in [SlaveSales.Status::Open, SlaveSales.Status::Released]) then
                        Error(OpenSalesSlaveErr, SlaveCompany.Name);

                    SlavePurch.ChangeCompany(SlaveCompany.Name);
                    SlavePurch.SetRange("Bill-to Contact No.", Rec."No.");
                    if SlavePurch.FindFirst() and (SlavePurch.Status in [SlavePurch.Status::Open, SlavePurch.Status::Released]) then
                        Error(OpenPurchSlaveErr, SlaveCompany.Name);
                until SlaveCompany.Next() = 0;
        end;
    end;

    // Delete Replication: Remove from Slaves

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterDeleteEvent', '', true, true)]
    local procedure ContactOnAfterDelete(var Rec: Record Contact; RunTrigger: Boolean)
    var
        ZynCompany, SlaveCompany : Record ZYN_CustomCompany;
        SlaveContact: Record Contact;
    begin
        if IsSyncing then
            exit;

        if not ZynCompany.Get(COMPANYNAME) then
            exit;

        IsSyncing := true;

        if ZynCompany."Is Master" then begin
            DeleteRelationsAndCustomerVendor(Rec, COMPANYNAME);

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

    // Helper: Delete Relations & Linked Customer/Vendor

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

    // Contact Insert Replication

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterInsertEvent', '', true, true)]
    local procedure ContactOnAfterInsert(var Rec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany, SlaveCompany : Record ZYN_CustomCompany;
        NewContact: Record Contact;
    begin
        if IsSyncing then
            exit;

        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        if MasterCompany."Is Master" then begin
            IsSyncing := true;
            SingleInstanceMgt.SetFromCreateAs(); // Prevent relation replication
            SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    NewContact.ChangeCompany(SlaveCompany.Name);
                    if not NewContact.Get(Rec."No.") then begin
                        StartSlaveContactCreation();
                        NewContact.Init();
                        NewContact.TransferFields(Rec, true);
                        NewContact."Contact Business Relation" := NewContact."Contact Business Relation"::None; // Force None
                        NewContact.Insert(true);
                        EndSlaveContactCreation();
                    end;
                until SlaveCompany.Next() = 0;
            SingleInstanceMgt.ClearFromCreateAs();
            IsSyncing := false;
        end;
    end;

    // Contact Modify Replication

    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnAfterModifyEvent', '', true, true)]
    local procedure ContactOnAfterModify(var Rec: Record Contact; var xRec: Record Contact; RunTrigger: Boolean)
    var
        MasterCompany, SlaveCompany : Record ZYN_CustomCompany;
        SlaveContact: Record Contact;
        MasterRef, SlaveRef : RecordRef;
        Field, SlaveField : FieldRef;
        i: Integer;
        IsDifferent: Boolean;
    begin
        if IsSyncing then
            exit;

        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        if MasterCompany."Is Master" then begin
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
                            if Field.Number = 1 then // Skip primary key
                                continue;
                            SlaveField := SlaveRef.Field(Field.Number);
                            if SlaveField.Value <> Field.Value then begin
                                IsDifferent := true;
                                break;
                            end;
                        end;

                        if IsDifferent then begin
                            IsSyncing := true;
                            SingleInstanceMgt.SetFromCreateAs();
                            StartSlaveContactCreation();
                            SlaveContact.TransferFields(Rec, false);
                            SlaveContact."Contact Business Relation" := SlaveContact."Contact Business Relation"::None;
                            SlaveContact.Modify(true);
                            EndSlaveContactCreation();
                            SingleInstanceMgt.ClearFromCreateAs();
                            IsSyncing := false;
                        end;
                    end;
                until SlaveCompany.Next() = 0;
        end else if (not MasterCompany."Is Master") and (MasterCompany."Master Company Name" <> '') then
                Error(ModifyContactInSlaveErr);
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
