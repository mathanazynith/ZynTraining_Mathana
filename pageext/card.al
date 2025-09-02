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
                    LogListPage: Page "Log List";
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
                RunObject = page "Modify List";
                RunPageLink = "Customer No."= field("No.") ;
            }
        }
    }
}


