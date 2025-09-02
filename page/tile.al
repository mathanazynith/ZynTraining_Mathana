page 50119 "customecard"
{
    PageType = CardPart;
    SourceTable = "Visit Log";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            cuegroup(Overview)
            {
                field("Today's Visits"; TodayLogCount)
                {
                    ApplicationArea = All;
                    Caption = 'My tiles';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        CustomerRec: Record Customer;
                        VisitLogRec: Record "Visit Log";
                        TemporaryTable: Record Customer temporary;
                        Today: Date;

                    begin
                        Today := WorkDate();
                        VisitLogRec.SetRange("Visit Date", Today);

                        if VisitLogRec.FindSet() then begin
                            repeat
                                if CustomerRec .get(VisitLogRec."Customer No.") then begin
                                    if not TemporaryTable.get(VisitLogRec."Customer No.") then begin
                                        TemporaryTable := CustomerRec;
                                        TemporaryTable.Insert();
                                    end;
                                end;
                            until VisitLogRec.Next() = 0;
                        end;
                        Page.RunModal(page::"Customer List", TemporaryTable);
                    end;


                }
            }
        }
    }

    var
        TodayLogCount: Integer;
        VisitLogRec: Record "Visit Log";
        Today: Date;

    trigger OnOpenPage()
    begin
        Today := WorkDate();
        TodayLogCount := 0;
        VisitLogRec.Reset();
        VisitLogRec.SetRange("Visit Date", Today);
        TodayLogCount := VisitLogRec.Count();
    end;



}
