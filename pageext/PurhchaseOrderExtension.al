pageextension 50111"PurchaseOrderExt" extends "Purchase Order"
{
    layout
    {
        modify("Document Date")
        {
            
            Visible = true;
        }

        addafter("Document Date")
        {
            field(" Approval Status"; Rec."Custom Approval Status")
            {
                ApplicationArea = All;
                Caption = 'Approval Status';
            }
        }
    }
}
