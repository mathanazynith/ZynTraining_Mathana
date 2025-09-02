page 50116 "Filtered Contact List"
{
    PageType = List;
    SourceTable = Contact;
    ApplicationArea = All;
    UsageCategory = None;

    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.") { }
                field(Name; rec.Name) { }
                field("Company Name"; rec."Company Name") { }
                field("Contact Business Relation"; rec."Contact Business Relation") { }
                field("Phone No."; rec."Phone No.") { }
                field("E-Mail"; rec."E-Mail") { }
                field("Sales person code"; rec."Salesperson Code") { }
                field("territory code"; rec."Territory Code") { }
            }
        }
    }

    actions
    {
       
    }
}
