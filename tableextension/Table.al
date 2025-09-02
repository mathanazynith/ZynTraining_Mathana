tableextension 50101 "PurchaseHeaderExt" extends "Purchase Header"
{
    fields
    {
        field(50101; "Custom Approval Status"; Enum "Custom Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
        }
    }
}
