page 50133 "Technician Problems"
{
    PageType = ListPart;
    SourceTable = "Customer Problem";
    ApplicationArea = All;
    Caption = 'Assigned Problems';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field(Problem; Rec.Problem) { ApplicationArea = All; }
                field("Problem Description"; Rec."Problem Description") { ApplicationArea = All; }
                field("Report Date"; Rec."Report Date") { ApplicationArea = All; }
               
            }
        }
    }

}