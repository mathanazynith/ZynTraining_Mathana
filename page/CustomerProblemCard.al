page 50104 "Customer Problem Card"
{
    PageType = Card;
    SourceTable = "Customer Problem";
    ApplicationArea = All;
    Caption = 'Log Problem';

    layout
    {
        area(content)
        {
            group("Customer Problem Details")
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Customer Name";rec."Customer Name"){}

                field(Problem; Rec.Problem)
                {
                    ApplicationArea = All;
                }

                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.Technician := ''; 
                    end;
                }

                field(Technician; Rec.Technician)
                {
                    ApplicationArea = All;
                    Caption='Technician';


                   
                }

            }

            field("Problem Description"; Rec."Problem Description")
            {
                ApplicationArea = All;
            }

            field("Report Date"; Rec."Report Date")
            {
                ApplicationArea = All;
            }
        }
    }
    var
        select: Integer;
}
