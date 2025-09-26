pageextension 50104 CustomerCardExt extends "Customer Card"
{
    actions
    {
        addlast(processing)
        {
            action(cusLog)
            {
                ApplicationArea = All;
                Caption = 'Customer Log';
                Image = Log; 
               trigger OnAction()
                var
                    LogListPage: Page "ZYN_Log List";
                begin
                    LogListPage.SetCustomerNo(Rec."No.");
                    LogListPage.RunModal();
                end;
            }
             action(ModLog)
            {
                ApplicationArea = All;
                Caption = 'Modify Log';
                Image = Edit; 
                RunObject = page "ZYN_Modified List";
                RunPageLink = "Customer No."= field("No.") ;
            }
        }
    }
}


