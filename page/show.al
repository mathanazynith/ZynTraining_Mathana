page 50107 "Customer Visit Purpose List"
{
    PageType = List;
    SourceTable = "Visit Log";
    ApplicationArea = All;
    Caption = 'Customer Visit Purpose List';
 
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer Name"; GetCustomerName())
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
 
                field("Purpose"; Rec."Purpose")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
 
    trigger OnOpenPage()
    begin
     
        Rec.SetRange("Visit Date", WorkDate);
    end;
 
    local procedure GetCustomerName(): Text[100]
    var
        Cust: Record Customer;
    begin
        if Cust.Get(Rec."Customer No.") then
            exit(Cust.Name)
        else
            exit('');
    end;
}
 
 