pageextension 50113 SalesInvoiceCardExt extends "Sales Invoice"
  
{
    layout
    {
        addlast(General)
        {
            field("Begin Text Code"; Rec."Begin Text Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a Begin Text Code for this sales invoice.';
             
            }

        }

        addlast(Content)
        {
            part(StandardTextLines; "Standard Text Line Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("Begin Text Code ");
                             
            }
        }
    }

    
}