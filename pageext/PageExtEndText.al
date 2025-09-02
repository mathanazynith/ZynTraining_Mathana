pageextension 50134 SalesInvoiceCardedExt extends "Sales Invoice"
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
            part(StandardTextContent; "End Text Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("End Text Code");
            }
        }
    }

    
    
}
