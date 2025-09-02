pageextension 50131 SalesCreditMemoCardedExt extends "Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("End Text Code"; Rec."End Text Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an End Text Code for this sales invoice.';
               
            }
        }

        addlast(Content)
        {
            part(Text ; "Text Part Ending")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("End Text Code");
            }
        }
    }

    
   
}
