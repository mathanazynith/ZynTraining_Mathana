page 50225 "ZYN_Employee Asset Cue FactBox"
{
    PageType = CardPart;
    SourceTable = "ZYN_Employee Asset";
    Caption = 'Employee Asset Overview';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup("Assets by Status")
            {
                field(AssignedCount; GetAssignedCount())
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';

                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.SetRange("Employee ID", Rec."Employee ID");
                        EA.SetRange("Status", EA.Status::Assigned);
                        PAGE.Run(PAGE::"ZYN_Employee Asset List", EA);
                    end;
                }

                field(ReturnedCount; GetReturnedCount())
                {
                    ApplicationArea = All;
                    Caption = 'Returned';

                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.SetRange("Employee ID", Rec."Employee ID");
                        EA.SetRange("Status", EA.Status::Returned);
                        PAGE.Run(PAGE::"ZYN_Employee Asset List", EA);
                    end;
                }

                field(LostCount; GetLostCount())
                {
                    ApplicationArea = All;
                    Caption = 'Lost';

                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.SetRange("Employee ID", Rec."Employee ID");
                        EA.SetRange("Status", EA.Status::Lost);
                        PAGE.Run(PAGE::"ZYN_Employee Asset List", EA);
                    end;
                }
            }
        }
    }

    var
        EmpAsset: Record "ZYN_Employee Asset";

    local procedure GetAssignedCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange("Employee ID", Rec."Employee ID");
        EmpAsset.SetRange("Status", EmpAsset.Status::Assigned);
        exit(EmpAsset.Count());
    end;

    local procedure GetReturnedCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange("Employee ID", Rec."Employee ID");
        EmpAsset.SetRange("Status", EmpAsset.Status::Returned);
        exit(EmpAsset.Count());
    end;

    local procedure GetLostCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange("Employee ID", Rec."Employee ID");
        EmpAsset.SetRange("Status", EmpAsset.Status::Lost);
        exit(EmpAsset.Count());
    end;
}
