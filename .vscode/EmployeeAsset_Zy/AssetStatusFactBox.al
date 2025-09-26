page 50230 "ZYN_Asset Status FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "ZYN_Employee Asset";
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
                    DrillDownPageId = "ZYN_Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Assigned);
                        PAGE.Run(PAGE::"ZYN_Employee Asset List", EA);
                    end;
                }

                field(ReturnedCount; GetReturnedCount())
                {
                    ApplicationArea = All;
                    Caption = 'Returned';
                    DrillDownPageId = "ZYN_Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Returned);
                        PAGE.Run(PAGE::"ZYN_Employee Asset List", EA);
                    end;
                }

                field(LostCount; GetLostCount())
                {
                    ApplicationArea = All;
                    Caption = 'Lost';
                    DrillDownPageId = "ZYN_Employee Asset List";
                    trigger OnDrillDown()
                    var
                        EA: Record "ZYN_Employee Asset";
                    begin
                        EA.Reset();
                        EA.SetRange(Status, EA.Status::Lost);
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
