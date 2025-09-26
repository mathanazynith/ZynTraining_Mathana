page 50135 "ZYN_Log List"
{
    PageType = List;
    SourceTable = "ZYN_Visit Log";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Log List';
    InsertAllowed = false;
    Editable = false;
    CardPageId = "ZYN_Log List card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                
                field("Customer No.";Rec."Customer No.") { }
                field("Date";Rec."Visit Date") { }
                field(Purpose;Rec.Purpose) { }
                field("Notes";Rec."Notes") { }
            }
        }
    }
     actions
    {
        area(processing)
        {
        }
    }

    procedure SetCustomerNo(CustNo: Code[20])
    begin
        Rec.SetRange("Customer No.", CustNo);
    end;
}