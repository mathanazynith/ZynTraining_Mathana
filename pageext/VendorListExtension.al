pageextension 50280 ZYN_VendorListExt extends "Vendor List"
{
    actions
    {
        addlast(processing)
        {
            action(SendToSlave)
            {
                Caption = 'Send To';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SelectionVend: Record Vendor;
                    ZynCompany: Record "ZYN_CustomCompany";
                    TargetCompany: Record "ZYN_CustomCompany";
                    ContactReplicator: Codeunit "ZYN_CustVendReplication";
                    CurrentCompName: Text;
                    CompanyName: Text;
                begin
                    // Get the current company name correctly
                    CurrentCompName := CompanyName();

                    // Collect selected customers on the page
                    CurrPage.SetSelectionFilter(SelectionVend);
                    if not SelectionVend.FindFirst() then
                        Error('Please select at least one customer.');

                    // Ensure current company exists in ZYN_CustomCompany
                    ZynCompany.Reset();
                    ZynCompany.SetRange(Name, CurrentCompName);
                    if not ZynCompany.FindFirst() then
                        Error('Current company (%1) is not registered in ZYN_CustomCompany.', CurrentCompName);

                    // Filter slave companies for current master
                    TargetCompany.Reset();
                    TargetCompany.SetRange("Master Company Name", ZynCompany.Name);
                    if not TargetCompany.FindFirst() then
                        Error('No slave companies found for current master company (%1).', ZynCompany.Name);

                    // Show lookup page to select the target slave company
                    if PAGE.RunModal(PAGE::"ZYN_CustomCompanyList", TargetCompany) = ACTION::LookupOK then begin
                        CompanyName := TargetCompany.Name;

                        // Iterate selected customers and replicate each to the chosen slave
                        SelectionVend.Reset();
                        CurrPage.SetSelectionFilter(SelectionVend);
                        if SelectionVend.FindSet() then
                            repeat
                             ContactReplicator.SendVendorToSlave(SelectionVend, CompanyName);
                            until SelectionVend.Next() = 0;
                    end;
                end;
            }
        }
    }
}



