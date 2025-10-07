codeunit 50274 "ZYN_CustVendReplication"
{
    Subtype = Normal;

    var
        IsSlaveSendAction: Boolean;
        IsSyncing: Boolean;

    // Flag toggler used by other replication codeunits
    procedure SetIsSlaveSendAction(Value: Boolean)
    begin
        IsSlaveSendAction := Value;
    end;

    procedure SendCustomerToSlave(var Customer: Record Customer; TargetCompanyName: Text)
    var
        NewCustomer: Record Customer;
        Contact: Record Contact;
        ContactRel: Record "Contact Business Relation";
        FoundContact: Boolean;
        MarketingSetup: Record "Marketing Setup";
    begin
        if not Customer.Get(Customer."No.") then
            exit;

        IsSlaveSendAction := true;

        // Change context
        NewCustomer.ChangeCompany(TargetCompanyName);
        Contact.ChangeCompany(TargetCompanyName);
        ContactRel.ChangeCompany(TargetCompanyName);

        // Replicate customer
        if not NewCustomer.Get(Customer."No.") then begin
            NewCustomer.Init();
            NewCustomer.TransferFields(Customer, true);
            NewCustomer.Insert(false);
        end;

        //  Find or create contact
        FoundContact := Contact.Get(Customer."No.");
        if not FoundContact then begin
            Contact.Reset();
            Contact.SetRange(Name, Customer.Name);
            FoundContact := Contact.FindFirst();
        end;

        if not FoundContact then begin
            Contact.Init();
            Contact."No." := Customer."No.";
            Contact.Name := Customer.Name;
            Contact.Insert(false);
        end;
        // Ensure Contact Business Relation exists
        ContactRel.Reset();
        ContactRel.SetRange("Contact No.", Contact."No.");
        ContactRel.SetRange("Business Relation Code", 'CUST');

        if not ContactRel.FindFirst() then begin
            ContactRel.Init();
            ContactRel."Contact No." := Contact."No.";
            ContactRel."Link to Table" := ContactRel."Link to Table"::Customer;
            ContactRel."Business Relation Code" := 'CUST';
            ContactRel."No." := Customer."No.";
            ContactRel."Business Relation Description" := Customer.Name;
            ContactRel."Contact Name" := Contact.Name;
            ContactRel.Insert(false);
        end;
        UpdateContactRelationField(Contact, ContactRel);
        IsSlaveSendAction := false;
    end;

    //  MAIN: VENDOR REPLICATION FLOW
    procedure SendVendorToSlave(var Vendor: Record Vendor; TargetCompany: Text)
    var
        NewVendor: Record Vendor;
        Contact: Record Contact;
        ContactRel: Record "Contact Business Relation";
        BusinessRel: Record "Business Relation";
    begin
        IsSlaveSendAction := true;

        // Switch company context
        NewVendor.ChangeCompany(TargetCompany);
        Contact.ChangeCompany(TargetCompany);
        ContactRel.ChangeCompany(TargetCompany);
        BusinessRel.ChangeCompany(TargetCompany);

        // Ensure Vendor exists
        if not NewVendor.Get(Vendor."No.") then begin
            NewVendor.Init();
            NewVendor.TransferFields(Vendor, true);
            NewVendor.Insert(false);
        end;

        // Find the contact linked to this vendor
        if not Contact.Get(Vendor."No.") then begin
            Contact.Reset();
            Contact.SetRange(Name, Vendor.Name);
            if not Contact.FindFirst() then begin
                Contact.Init();
                Contact."No." := Vendor."No.";
                Contact.Name := Vendor.Name;
                Contact.Insert(false);
            end;
        end;

        // Ensure Business Relation 'VEND' exists
        if not BusinessRel.Get('VEND') then begin
            BusinessRel.Init();
            BusinessRel.Code := 'VEND';
            BusinessRel.Description := 'Vendor';
            BusinessRel.Insert(false);
        end;

        // Insert or update Contact Business Relation
        ContactRel.Reset();
        ContactRel.SetRange("Contact No.", Contact."No.");
        ContactRel.SetRange("Business Relation Code", 'VEND');

        if not ContactRel.FindFirst() then begin
            ContactRel.Init();
            ContactRel."Contact No." := Contact."No.";
            ContactRel."Link to Table" := ContactRel."Link to Table"::Vendor;
            ContactRel."Business Relation Code" := 'VEND';
            ContactRel."No." := Vendor."No.";
            ContactRel."Business Relation Description" := Vendor.Name;
            ContactRel."Contact Name" := Contact.Name;
            ContactRel.Insert(false);
        end;

        // Refresh the Contact Business Relation field (handles Multiple)
        UpdateContactRelationField(Contact, ContactRel);
        IsSlaveSendAction := false;
    end;

    procedure UpdateContactRelationField(var Contact: Record Contact; var ContactRel: Record "Contact Business Relation")
    var
        CustRel, VendRel : Record "Contact Business Relation";
    begin
        CustRel.ChangeCompany(ContactRel.CurrentCompany);
        VendRel.ChangeCompany(ContactRel.CurrentCompany);
        CustRel.Reset();
        CustRel.SetRange("Contact No.", Contact."No.");
        CustRel.SetRange("Link to Table", CustRel."Link to Table"::Customer);
        VendRel.Reset();
        VendRel.SetRange("Contact No.", Contact."No.");
        VendRel.SetRange("Link to Table", VendRel."Link to Table"::Vendor);
        if CustRel.FindFirst() and VendRel.FindFirst() then
            Contact."Contact Business Relation" := Contact."Contact Business Relation"::Multiple
        else if CustRel.FindFirst() then
            Contact."Contact Business Relation" := Contact."Contact Business Relation"::Customer
        else if VendRel.FindFirst() then
            Contact."Contact Business Relation" := Contact."Contact Business Relation"::Vendor
        else
            Contact."Contact Business Relation" := Contact."Contact Business Relation"::None;

        Contact.Modify(false);
    end;

    //  VALIDATION: Prevent changes in Slave companies
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', true, true)]
    local procedure CustomerOnBeforeInsert(var Rec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') and not IsSlaveSendAction then
                Error(CreateCustomerInSlaveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', true, true)]
    local procedure CustomerOnBeforeModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
                Error(ModifyCustomerInSlaveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure CustomerOnBeforeDelete(var Rec: Record Customer; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
                Error(DeleteCustomerInSlaveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeInsertEvent', '', true, true)]
    local procedure VendorOnBeforeInsert(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then 
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') and not IsSlaveSendAction then
                Error(CreateVendorInSlaveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeModifyEvent', '', true, true)]
    local procedure VendorOnBeforeModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
                Error(ModifyVendorInSlaveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure VendorOnBeforeDelete(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        ZynCompany: Record ZYN_CustomCompany;
    begin
        if ZynCompany.Get(COMPANYNAME) then
            if (not ZynCompany."Is Master") and (ZynCompany."Master Company Name" <> '') then
                Error(DeleteVendorInSlaveErr);
    end;

    local procedure DeleteCustomerFromSlave(CustomerNo: Code[20]; SlaveCompany: Text)
    var
        SlaveCust: Record Customer;
        SlaveContact: Record Contact;
        ContactRel: Record "Contact Business Relation";
    begin
        // operate in slave company context
        SlaveCust.ChangeCompany(SlaveCompany);
        SlaveContact.ChangeCompany(SlaveCompany);
        ContactRel.ChangeCompany(SlaveCompany);

        //  Delete the customer record in slave (if present)
        if SlaveCust.Get(CustomerNo) then
            SlaveCust.Delete(false);

        //  Delete only Contact Business Relation rows that reference this customer
        ContactRel.Reset();
        ContactRel.SetRange("Business Relation Code", 'CUST');
        ContactRel.SetRange("No.", CustomerNo);
        if ContactRel.FindSet() then
            repeat
                ContactRel.Delete(false);
            until ContactRel.Next() = 0;

        //  Recalculate the Contact."Contact Business Relation" enum for the related contact (if exists)
        if SlaveContact.Get(CustomerNo) then begin
            // Use existing helper to compute Multiple/Customer/Vendor/None
            UpdateContactRelationField(SlaveContact, ContactRel);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterDeleteEvent', '', true, true)]
    local procedure CustomerOnAfterDelete(var Rec: Record Customer; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_CustomCompany;
        SlaveCompany: Record ZYN_CustomCompany;
        Contact: Record Contact;
        ContactRel: Record "Contact Business Relation";
        CustVendReplication: Codeunit "ZYN_CustVendReplication";
    begin
        if IsSyncing then
            exit;

        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        if not MasterCompany."Is Master" then
            exit;

        IsSyncing := true;

        SlaveCompany.Reset();
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                // Delete Customer in slave
                DeleteCustomerFromSlave(Rec."No.", SlaveCompany.Name);

                // --- Recalculate Contact Business Relation ---
                Contact.ChangeCompany(SlaveCompany.Name);
                ContactRel.ChangeCompany(SlaveCompany.Name);

                if Contact.Get(Rec."No.") then begin
                    CustVendReplication.UpdateContactRelationField(Contact, ContactRel);
                end else begin
                    Contact.Reset();
                    Contact.SetRange(Name, Rec.Name);
                    if Contact.FindFirst() then
                        CustVendReplication.UpdateContactRelationField(Contact, ContactRel);
                end;
            until SlaveCompany.Next() = 0;

        IsSyncing := false;
    end;


    local procedure DeleteVendorFromSlave(VendorNo: Code[20]; SlaveCompany: Text)
    var
        SlaveVend: Record Vendor;
        SlaveContact: Record Contact;
        ContactRel: Record "Contact Business Relation";
    begin
        // operate in slave company context
        SlaveVend.ChangeCompany(SlaveCompany);
        SlaveContact.ChangeCompany(SlaveCompany);
        ContactRel.ChangeCompany(SlaveCompany);

        //  Delete the vendor record in slave (if present)
        if SlaveVend.Get(VendorNo) then
            SlaveVend.Delete(false);

        //  Delete only Contact Business Relation rows that reference this vendor
        ContactRel.Reset();
        ContactRel.SetRange("Business Relation Code", 'VEND');
        ContactRel.SetRange("No.", VendorNo);
        if ContactRel.FindSet() then
            repeat
                ContactRel.Delete(false);
            until ContactRel.Next() = 0;

        // Recalculate the Contact."Contact Business Relation" enum for the related contact (if exists)
        if SlaveContact.Get(VendorNo) then begin
            // Use existing helper to compute Multiple/Customer/Vendor/None
            UpdateContactRelationField(SlaveContact, ContactRel);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterDeleteEvent', '', true, true)]
    local procedure VendorOnAfterDelete(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        MasterCompany: Record ZYN_CustomCompany;
        SlaveCompany: Record ZYN_CustomCompany;
        Contact: Record Contact;
        ContactRel: Record "Contact Business Relation";
        CustVendReplication: Codeunit "ZYN_CustVendReplication";
    begin
        if IsSyncing then
            exit;

        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        if not MasterCompany."Is Master" then
            exit;

        IsSyncing := true;

        SlaveCompany.Reset();
        SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
        if SlaveCompany.FindSet() then
            repeat
                // Delete Vendor in slave
                DeleteVendorFromSlave(Rec."No.", SlaveCompany.Name);

                // Recalculate Contact Business Relation 
                Contact.ChangeCompany(SlaveCompany.Name);
                ContactRel.ChangeCompany(SlaveCompany.Name);

                if Contact.Get(Rec."No.") then begin
                    // refresh the contact's business relation after deletion
                    CustVendReplication.UpdateContactRelationField(Contact, ContactRel);
                end else begin
                    // handle case where contact number differs
                    Contact.Reset();
                    Contact.SetRange(Name, Rec.Name);
                    if Contact.FindFirst() then
                        CustVendReplication.UpdateContactRelationField(Contact, ContactRel);
                end;
            until SlaveCompany.Next() = 0;

        IsSyncing := false;
    end;

    procedure StartSlaveCustomerReplication()
    begin
        IsSlaveSendAction := true;
    end;

    procedure EndSlaveCustomerReplication()
    begin
        IsSlaveSendAction := false;
    end;

    // CUSTOMER MODIFICATION REPLICATION IN SALVE COMPANIES
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', true, true)]
    local procedure CustomerOnAfterModify(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    var
        MasterCompany, SlaveCompany : Record ZYN_CustomCompany;
        SlaveCustomer: Record Customer;
        MasterRef, SlaveRef : RecordRef;
        Field, SlaveField : FieldRef;
        i: Integer;
        IsDifferent: Boolean;
        SingleInstanceMgt: Codeunit "ZYN_CustomerVendorActContMgmt";
    begin
        // Prevent recursion
        if IsSyncing then
            exit;

        // Ensure current company is registered
        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        // Only replicate from Master company to its slaves
        if MasterCompany."Is Master" then begin
            SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    SlaveCustomer.ChangeCompany(SlaveCompany.Name);

                    // Only replicate if customer exists in slave
                    if SlaveCustomer.Get(Rec."No.") then begin
                        MasterRef.GetTable(Rec);
                        SlaveRef.GetTable(SlaveCustomer);
                        IsDifferent := false;

                        // Compare all fields (skip PK)
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
                            StartSlaveCustomerReplication(); // Custom procedure (optional but cleaner)
                            SlaveCustomer.TransferFields(Rec, false);
                            SlaveCustomer.Modify(true);
                            EndSlaveCustomerReplication();
                            SingleInstanceMgt.ClearFromCreateAs();
                            IsSyncing := false;
                        end;
                    end;
                until SlaveCompany.Next() = 0;

        end
    end;

    // VENDOR MODIFICATION REPLICATION IN SLAVE COMPANIES
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', true, true)]
    local procedure VendorOnAfterModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        MasterCompany, SlaveCompany : Record ZYN_CustomCompany;
        SlaveVendor: Record Vendor;
        MasterRef, SlaveRef : RecordRef;
        Field, SlaveField : FieldRef;
        i: Integer;
        IsDifferent: Boolean;
        SingleInstanceMgt: Codeunit "ZYN_CustomerVendorActContMgmt"; // ✅ Added declaration
    begin
        // Prevent recursion
        if IsSyncing then
            exit;

        // Verify that company record exists
        if not MasterCompany.Get(COMPANYNAME) then
            exit;

        // Only replicate when in Master company
        if MasterCompany."Is Master" then begin
            SlaveCompany.SetRange("Master Company Name", MasterCompany.Name);
            if SlaveCompany.FindSet() then
                repeat
                    SlaveVendor.ChangeCompany(SlaveCompany.Name);

                    // Replicate only if vendor exists in slave
                    if SlaveVendor.Get(Rec."No.") then begin
                        MasterRef.GetTable(Rec);
                        SlaveRef.GetTable(SlaveVendor);
                        IsDifferent := false;

                        // Compare each field (ignore PK/system)
                        for i := 1 to MasterRef.FieldCount do begin
                            Field := MasterRef.FieldIndex(i);
                            if Field.Class <> FieldClass::Normal then
                                continue;
                            if Field.Number = 1 then // Skip primary key "No."
                                continue;

                            SlaveField := SlaveRef.Field(Field.Number);
                            if SlaveField.Value <> Field.Value then begin
                                IsDifferent := true;
                                break;
                            end;
                        end;

                        // If differences found, sync changes
                        if IsDifferent then begin
                            IsSyncing := true;
                            SingleInstanceMgt.SetFromCreateAs();
                            StartSlaveVendorReplication(); // ✅ helper procedure
                            SlaveVendor.TransferFields(Rec, false);
                            SlaveVendor.Modify(true);
                            EndSlaveVendorReplication();
                            SingleInstanceMgt.ClearFromCreateAs();
                            IsSyncing := false;
                        end;
                    end;
                until SlaveCompany.Next() = 0;
        end
    end;

    procedure StartSlaveVendorReplication()
    begin
        IsSlaveSendAction := true;
    end;

    procedure EndSlaveVendorReplication()
    begin
        IsSlaveSendAction := false;
    end;

    var
        CreateCustomerInSlaveErr: Label 'You cannot create customers in a slave company. Use the master company only.';
        ModifyCustomerInSlaveErr: Label 'You cannot modify customers in a slave company. Modify in the master company only.';
        DeleteCustomerInSlaveErr: Label 'You cannot delete customers in a slave company. Delete in the master company only.';
        CreateVendorInSlaveErr: Label 'You cannot create vendors in a slave company. Use the master company only.';
        ModifyVendorInSlaveErr: Label 'You cannot modify vendors in a slave company. Modify in the master company only.';
        DeleteVendorInSlaveErr: Label 'You cannot delete vendors in a slave company. Delete in the master company only.';

}