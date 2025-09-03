page 50230 "Asset Status FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "Employee Asset";
    Caption = 'Asset Status Overview';

    layout
    {
        area(content)
        {
            cuegroup("Asset Status")
            {
                field(AssignedCount; GetAssignedCount())
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';
                    DrillDownPageId = "Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Assigned);
                        PAGE.Run(PAGE::"Employee Asset List", EA);
                    end;
                }

                field(ReturnedCount; GetReturnedCount())
                {
                    ApplicationArea = All;
                    Caption = 'Returned';
                    DrillDownPageId = "Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Returned);
                        PAGE.Run(PAGE::"Employee Asset List", EA);
                    end;
                }

                field(LostCount; GetLostCount())
                {
                    ApplicationArea = All;
                    Caption = 'Lost';
                    DrillDownPageId = "Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Lost);
                        PAGE.Run(PAGE::"Employee Asset List", EA);
                    end;
                }
            }
        }
    }

    var
        EmpAsset: Record "Employee Asset";

    local procedure GetAssignedCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange(Status, EmpAsset.Status::Assigned);
        exit(EmpAsset.Count());
    end;

    local procedure GetReturnedCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange(Status, EmpAsset.Status::Returned);
        exit(EmpAsset.Count());
    end;

    local procedure GetLostCount(): Integer
    begin
        EmpAsset.Reset();
        EmpAsset.SetRange(Status, EmpAsset.Status::Lost);
        exit(EmpAsset.Count());
    end;
}
