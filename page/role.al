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
            group(Subscription)
            {
                // part("customerCardpart"; customecard)  
                // {

                // }
                part(SubscriptionCue; "Subscription Cue Page")
            {
                ApplicationArea = All;
            }
            part(RecurringInvoiceAmount; "Recurring Invoice FactBox")
            {
                ApplicationArea = All;
            }
            }
        }
    }




    actions
    {
        area(Sections)
        {
            group(cutomer)  
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
             group(EmployeeAssetManagement){
             action("Employee Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Assets';
                    RunObject = page "Employee Asset List";
                    
                }
                action("Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Assets';
                    RunObject = page "Assets List";
                    
                }
                action("Assets Category")
                {
                    ApplicationArea = All;
                    Caption = 'Assets Category';
                    RunObject = page "Asset Type list";
                    
                }
            }
            group(Employees){
             action("Employee List")
                {
                    ApplicationArea = All;
                    Caption = 'Employees';
                    RunObject = page "Employees List";
                    
                }
                action("Leave Category")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Category';
                    RunObject = page "Leave Category List";
                    
                }
                action("Leave Request")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Request';
                    RunObject = page "Leave Request List";
                    
                }
            }
            group(Expenses){
             action("Expense category")
                {
                    ApplicationArea = All;
                    Caption = 'Expense Category';
                    RunObject = page "Expense Category List";
                    
                }
                action("Expense List")
                {
                    ApplicationArea = All;
                    Caption = 'Expenses';
                    RunObject = page "Expense Tracker List";
                    
                }
                
            }
            group(Budget){
             action("Budget List")
                {
                    ApplicationArea = All;
                    Caption = 'Budget';
                    RunObject = page "Budget Tracker List";
                    
                }
                
            }
            group(Income){
             action("IncomeList")
                {
                    ApplicationArea = All;
                    Caption = 'Income';
                    RunObject = page "Income Tracker List";
                    
                }
                action("IncomeCategory")
                {
                    ApplicationArea = All;
                    Caption = 'Income Category';
                    RunObject = page "Income Category List";
                    
                }
            }
        }

    }



}