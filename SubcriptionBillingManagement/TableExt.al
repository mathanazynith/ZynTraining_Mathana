tableextension 50355 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50300; "From Subscription"; Boolean)
        {
            Caption = 'From Subscription';
            DataClassification = CustomerContent;
        }
    }
}
