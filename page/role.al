page 50105 "My Role Center"
{
    PageType = RoleCenter;
    Caption = 'my role centre';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(RoleCenter)
        {
            group(cutomer)
            {
                part("customerCardpart"; customecard)
                {

                }
            }
        }
    }




    actions
    {
        area(Sections)
        {
            group(customer)
            {
                Caption = 'customer';

                action(customerLogs)
                {
                    Caption = 'customer list';
                    //RunObject = page 22;
                }
                action(customerContact)
                {
                    Caption = 'customer contact';


                }
            }
            group(Vendor)
            {
                Caption = 'Vendor';

                action(VendorLogs)
                {
                    Caption = 'Vendor contact';
                    //RunObject= page 22;
                }
            }
            group(Banking)
            {
                Caption = 'Banking';

                action(BankContact)
                {
                    Caption = 'Bank contact';
                    //RunObject= page 22;
                }
            }
            group(EmployeeAsset)
            {
                Caption = 'Employee Assert';

                action(Asset)
                {
                    Caption = 'Asset';
                    RunObject= page 50198;
                }
            }
        }

    }



}