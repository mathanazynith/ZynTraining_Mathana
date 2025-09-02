page 50158 "Budget FactBox"
{
    PageType = ListPart;
    SourceTable = "Budget Tracker";
    ApplicationArea = All;
    Caption = 'Monthly Budget Overview';
    Editable = false; 

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Expense Category"; Rec."Expense Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        WorkDt: Date;
        FirstDay: Date;
        LastDay: Date;
        CurrentMonth: Integer;
        CurrentYear: Integer;
    begin
        
        WorkDt := WorkDate();
        CurrentMonth := Date2DMY(WorkDt, 2);
        CurrentYear := Date2DMY(WorkDt, 3);

        
        FirstDay := DMY2Date(1, CurrentMonth, CurrentYear);
        LastDay := CalcDate('<CM>', FirstDay);

        
        Rec.SetRange("From Date", FirstDay);
        Rec.SetRange("To Date", LastDay);
    end;
}
