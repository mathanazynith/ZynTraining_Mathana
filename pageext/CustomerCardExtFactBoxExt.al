pageextension 50138 CustomerCardFactBoxExt extends "Customer Card"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(CustomerOverview; "ZYN_Customer Overview FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            
        }
    }
}
