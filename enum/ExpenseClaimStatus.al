enum 50223 "ZYN_Expense Claim Status"
{
    Extensible = true;

    value(0; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(1; Approved)
    {
        Caption = 'Approved';
    }
    value(2; Rejected)
    {
        Caption = 'Rejected';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
