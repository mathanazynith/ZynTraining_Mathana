page 50105 "ZYN_My Role Center"
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
                part(SubscriptionCue; "Subscription Cue Page")
            {
                ApplicationArea = All;
            }
            part(RecurringInvoiceAmount; "ZYN_Recurring Invoice FactBox")
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
                   
                }
            }
            group(Banking)
            {
                Caption = 'Banking';

                action(BankContact)
                {
                    Caption = 'Bank contact';
                    
                }
            }
             group(EmployeeAssetManagement){
             action("Employee Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Assets';
                    RunObject = page "ZYN_Employee Asset List";
                    
                }
                action("Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Assets';
                    RunObject = page "ZYN_Assets List";
                    
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
                    RunObject = page "ZYN_Employees List";
                    
                }
                action("Leave Category")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Category';
                    RunObject = page "ZYN_Leave Category List";
                    
                }
                action("Leave Request")
                {
                    ApplicationArea = All;
                    Caption = 'Leave Request';
                    RunObject = page "ZYN_Leave Request List";
                    
                }
            }
            group(Expenses){
             action("Expense category")
                {
                    ApplicationArea = All;
                    Caption = 'Expense Category';
                    RunObject = page "ZYN_Expense Category List";
                    
                }
                action("Expense List")
                {
                    ApplicationArea = All;
                    Caption = 'Expenses';
                    RunObject = page "ZYN_Expense Tracker List";
                    
                }
                
            }
            group(Budget){
             action("Budget List")
                {
                    ApplicationArea = All;
                    Caption = 'Budget';
                    RunObject = page "ZYN_Budget Tracker List";
                    
                }
                
            }
            group(Income){
             action("IncomeList")
                {
                    ApplicationArea = All;
                    Caption = 'Income';
                    RunObject = page "ZYN_Income Tracker List";
                    
                }
                action("IncomeCategory")
                {
                    ApplicationArea = All;
                    Caption = 'Income Category';
                    RunObject = page "ZYN_Income Category List";
                    
                }
            }
        }

    }



}