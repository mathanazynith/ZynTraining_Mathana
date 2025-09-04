pageextension 50119 CustomerListFactExt extends "Customer List"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(CustomerOverview; "Customer Overview FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            part(CustomerSubscriptions; "Customer Subscription FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }
}
