pageextension 50116 ContactListExt extends "Contact List"

{
    actions
    {
        addlast(processing)
        {
            group(ContactList)
            {
                caption = 'Contact List';
                Image = Holiday;
                action(CustomerContact)
                {
                    Caption = 'CustomerContact';
                    Image = HumanResources;
                    ApplicationArea = All;

                    trigger OnAction()

                    var
                        ContactRec: Record Contact;
                        ContactBusinessRelation: Record "Contact Business Relation";
                        TemporaryTable: Record Contact temporary;
                        Today: Date;

                    begin

                        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);

                        if ContactBusinessRelation.FindSet() then begin
                            repeat
                                if ContactRec.get(ContactBusinessRelation."Contact No.") then begin
                                    if not TemporaryTable.get(ContactRec."No.") then begin
                                        TemporaryTable := ContactRec;
                                        TemporaryTable.Insert();
                                    end;
                                end;
                            until ContactBusinessRelation.Next() = 0;
                        end;
                        Page.RunModal(page::"ZYN_Filtered Contact List", TemporaryTable);
                    end;

                }
                action(VendorContact)
                {
                    Caption = 'VendorContact';
                    Image = HumanResources;
                    ApplicationArea = All;

                    trigger OnAction()

                    var
                        ContactRec: Record Contact;
                        ContactBusinessRelation: Record "Contact Business Relation";
                        TemporaryTable: Record Contact temporary;
                        Today: Date;

                    begin

                        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);

                        if ContactBusinessRelation.FindSet() then begin
                            repeat
                                if ContactRec.get(ContactBusinessRelation."Contact No.") then begin
                                    if not TemporaryTable.get(ContactRec."No.") then begin
                                        TemporaryTable := ContactRec;
                                        TemporaryTable.Insert();
                                    end;
                                end;
                            until ContactBusinessRelation.Next() = 0;
                        end;
                        Page.RunModal(page::"ZYN_Filtered Contact List", TemporaryTable);
                    end;
                 

                }
                action(BankContact)
                {
                    Caption = 'BankContact';
                    Image = HumanResources;
                    ApplicationArea = All;

                    trigger OnAction()

                    var
                        ContactRec: Record Contact;
                        ContactBusinessRelation: Record "Contact Business Relation";
                        TemporaryTable: Record Contact temporary;
                        Today: Date;

                    begin

                        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::"Bank Account");

                        if ContactBusinessRelation.FindSet() then begin
                            repeat
                                if ContactRec.get(ContactBusinessRelation."Contact No.") then begin
                                    if not TemporaryTable.get(ContactRec."No.") then begin
                                        TemporaryTable := ContactRec;
                                        TemporaryTable.Insert();
                                    end;
                                end;
                            until ContactBusinessRelation.Next() = 0;
                        end;
                        Page.RunModal(page::"ZYN_Filtered Contact List", TemporaryTable);
                    end;
                }
            }
        }

    }
}
