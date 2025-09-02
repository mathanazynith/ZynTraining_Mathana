page 50111 "Technician Card"
{
    PageType = Card;
    SourceTable = "Technician";
    ApplicationArea = All;
    Caption = 'Technician Card';

    layout
    {
        area(content)
        {
            group("Technician Details")
            {
                field("Tech. Id"; Rec."Tech. Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Name; rec.Name) { ApplicationArea = All; }
                field("Phone Number";rec. "Phone Number") { ApplicationArea = All; }
                field(Department; rec.Department) { ApplicationArea = All; }
            }
        }
    }
}
