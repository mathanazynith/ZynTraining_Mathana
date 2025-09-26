pageextension 50141 PostedSalesInvoicEndeExt extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Standard Code"; Rec."Begin text code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='standard code';
            }
            field("Ending Code"; Rec."End Text Code")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='Ending code';
            }
            field("Begin invoice"; Rec."Begin invoice")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='Begin invoice';
            }
            field("End invoice"; Rec."End invoice")
            {
                ApplicationArea = All;
                Editable = false;
                Caption='End invoice';
            }
        }
    }
}