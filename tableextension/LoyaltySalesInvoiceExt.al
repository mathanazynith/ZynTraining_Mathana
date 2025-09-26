tableextension 50128 SalesInvoiceHeaderExt extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Loyalty Points"; Integer)
        {
            Caption = 'Loyalty Points';
            DataClassification = CustomerContent;
        }
    }
}
