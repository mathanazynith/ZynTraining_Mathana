// pageextension 50274 "ZYN_CustomerListExt" extends "Customer List"
// {
//     actions
//     {
//         addlast(Processing)
//         {
//             action(SendToSlave)
//             {
//                 Caption = 'Send To';
//                 Image = SendTo;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     SelectionCust: Record Customer;
//                     ZynCompany: Record ZYN_CustomCompany;
//                     TargetCompany: Record ZYN_CustomCompany;
//                     ContactReplicator: Codeunit "ZYN_ContactReplication";
//                     CompanyName: Text;
//                 begin
//                     // Collect selected customers on the page
//                     CurrPage.SetSelectionFilter(SelectionCust);
//                     if not SelectionCust.FindFirst() then
//                         Error('Please select at least one customer.');

//                     // Ensure current company exists in your ZYN table
//                     if not ZynCompany.Get(COMPANYNAME) then
//                         Error('Current company is not registered in ZYN_CustomCompany.');

//                     // Filter slave companies for current master
//                     TargetCompany.Reset();
//                     TargetCompany.SetRange("Master Company Name", ZynCompany.Name);
//                     if not TargetCompany.FindFirst() then
//                         Error('No slave companies found for current master.');

//                     // Show lookup page (the page should be created: e.g. page 50273 "ZYN_CustomCompanyLookup")
//                     if PAGE.RunModal(PAGE::"ZYN_CustomCompanyList", TargetCompany) = ACTION::LookupOK then begin
//                         CompanyName := TargetCompany.Name;

//                         // Iterate selected customers and replicate each
//                         SelectionCust.Reset();
//                         CurrPage.SetSelectionFilter(SelectionCust);
//                         if SelectionCust.FindSet() then
//                             repeat
//                                 ContactReplicator.ReplicateCustomerToSlave(SelectionCust, CompanyName);
//                             until SelectionCust.Next() = 0;
//                     end;
//                 end;
//             }
//         }
//     }
// }

