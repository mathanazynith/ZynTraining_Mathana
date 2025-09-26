pageextension 50127 CustomerListExt extends "Customer card"
{
    layout
    {
        addlast(General)
        {
            field("Loyalty Points Allowed"; rec."Loyalty Points Allowed")
            {
                ApplicationArea = All;
            }
            field("Loyalty Points used"; rec."Loyalty Points used")
            {
                ApplicationArea = All;
                Editable=false;
            }
           
        }
    }
   
}