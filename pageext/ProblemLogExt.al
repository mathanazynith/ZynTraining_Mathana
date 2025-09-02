pageextension 50109 "CustomerCard_Ext_Problem" extends "Customer Card"
{
    actions
    {
        addlast(Processing)
        {
            action("Log Problem")
            {
                ApplicationArea = All;
                Caption = 'Problem';
                Image = Log;

                trigger OnAction()
                var
                    ProblemRec: Record "Customer Problem";
                    CustomerRec: Record Customer;
                begin
                    CustomerRec.Get(Rec."No.");
                    ProblemRec.Init();
                    ProblemRec."Customer No." := CustomerRec."No.";
                    ProblemRec."Customer Name" := CustomerRec.Name;
                    ProblemRec.Insert(true);
                    Page.Run(Page::"Customer Problem Card", ProblemRec);
                end;
            }
        }
    }
}
