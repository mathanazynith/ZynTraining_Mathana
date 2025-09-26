pageextension 50119 CustomerListFactExt extends "Customer List"
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
            part(CustomerSubscriptions; "ZYN_CustomerSubscripFactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }
}
