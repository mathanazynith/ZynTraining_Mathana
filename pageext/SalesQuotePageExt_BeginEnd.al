pageextension 50118 SalesQuoteCardExt extends "Sales Quote"
  
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
            part(StandardTextLines; "ZYN_Standard Text Line Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("Begin Text Code ");
                             
            }
        }
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
            part(StandardTextContent; "ZYN_End Text Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("End Text Code");
            }
        }
    }

    
}