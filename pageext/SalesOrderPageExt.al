pageextension 50117 SalesorderCardExt extends "Sales order"
  
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
                              "Document Type" = const(Order),
                            
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
            part(StandardTextContent; "End Text Part")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Text Code Type"=const("End Text Code");
            }
        }
        addlast(General)
        {
        field("Begin invoice"; Rec."Begin invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a Begin Text Code for this sales invoice.';
             
            }
        }
        addlast(General)
        {
            field("End invoice"; Rec."End invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a Begin Text Code for this sales invoice.';
             
            }
        }
    }

    
}