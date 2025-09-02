enum 50113 "Custom Approval Status"
{
    Extensible = true;
    Caption = ' Approval Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Pending)
    {
        Caption = 'Pending';
    }
    value(2; Approved)
    {
        Caption = 'Approved';
    }
    value(3; Escalated)
    {
        Caption = 'Escalated';
    }
}



